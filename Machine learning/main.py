
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression
from sklearn.cluster import KMeans
import joblib
import tkinter as tk
from tkinter import font
from tkinter import simpledialog, messagebox
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.impute import SimpleImputer

countries = pd.read_csv('countries.csv')
customers = pd.read_csv('coustmers.csv')
orders = pd.read_csv('orders.csv')
products = pd.read_csv('products.csv')
sales = pd.read_csv('sales.csv')

countries_numeric = countries.select_dtypes(include=['number'])
customers_numeric = customers.select_dtypes(include=['number'])
orders_numeric = orders.select_dtypes(include=['number'])
products_numeric = products.select_dtypes(include=['number'])
sales_numeric = sales.select_dtypes(include=['number'])

customers_with_countries = customers.merge(countries, left_on='Country', right_on='Name', how='left')

customers_with_countries_numeric = customers_with_countries.select_dtypes(include=['number'])

data = sales_numeric.merge(orders_numeric, on='OrderId').merge(customers_with_countries_numeric, on='CustomerId').merge(products_numeric, on='ProductId')

X = data.drop(columns=['Quantity'])  # Features
y = data['Quantity']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Remove columns that are entirely NaN from the dataset
X_train = X_train.dropna(axis=1, how='all')
X_test = X_test.dropna(axis=1, how='all')

# Impute missing values in the remaining feature matrix
imputer = SimpleImputer(strategy='mean')

# Fit the imputer on the training data and transform both train and test sets
X_train_imputed = imputer.fit_transform(X_train)
X_test_imputed = imputer.transform(X_test)

# Scale the data
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train_imputed)
X_test_scaled = scaler.transform(X_test_imputed)

# Train the Linear Regression model
sales_model = LinearRegression()
sales_model.fit(X_train_scaled, y_train)

# Save the model and scaler for later use
joblib.dump(sales_model, 'sales_model.pkl')
joblib.dump(scaler, 'scaler.pkl')
joblib.dump(imputer, 'imputer.pkl')  # Save the imputer too

#columns used to train
print("*************************************\nColumns used for Sales Prediction Model (X):")
print(y_train)
print("\n*************************************")

# Test the model
sales_predictions = sales_model.predict(X_test_scaled)
print(f"Sales Prediction Test Results: {sales_predictions[:5]}")

from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

# Calculate evaluation metrics
mae = mean_absolute_error(y_test, sales_predictions)
mse = mean_squared_error(y_test, sales_predictions)
r2 = r2_score(y_test, sales_predictions)

print(f"Mean Absolute Error: {mae}")
print(f"Mean Squared Error: {mse}")
print(f"R-squared: {r2}")

# Feature Selection: Remove unnecessary or irrelevant columns
X = data.drop(columns=['Quantity', 'OrderId', 'ProductId', 'CustomerId'])

# Check for missing values and identify columns with all missing values
missing_columns = X.columns[X.isnull().all()]
print("Columns with all missing values:", missing_columns)

# Drop columns that are completely missing
X = X.drop(columns=missing_columns)

# Target variable
y = data['Quantity']  # Adjust based on your actual target variable

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Impute missing values in the feature matrix
imputer = SimpleImputer(strategy='mean')
X_train_imputed = imputer.fit_transform(X_train)
X_test_imputed = imputer.transform(X_test)

# Scale the data (necessary for some algorithms)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train_imputed)
X_test_scaled = scaler.transform(X_test_imputed)

# Train a Decision Tree Regressor
tree_model = DecisionTreeRegressor(random_state=42)
tree_model.fit(X_train_scaled, y_train)

# Train a Random Forest Regressor
forest_model = RandomForestRegressor(n_estimators=100, random_state=42)
forest_model.fit(X_train_scaled, y_train)

# Test the models
tree_predictions = tree_model.predict(X_test_scaled)
forest_predictions = forest_model.predict(X_test_scaled)

# Evaluate Decision Tree
mae_tree = mean_absolute_error(y_test, tree_predictions)
mse_tree = mean_squared_error(y_test, tree_predictions)
r2_tree = r2_score(y_test, tree_predictions)
print(f"Decision Tree Results:\n MAE: {mae_tree}\n MSE: {mse_tree}\n R-squared: {r2_tree}\n")

# Evaluate Random Forest
mae_forest = mean_absolute_error(y_test, forest_predictions)
mse_forest = mean_squared_error(y_test, forest_predictions)
r2_forest = r2_score(y_test, forest_predictions)
print(f"Random Forest Results:\n MAE: {mae_forest}\n MSE: {mse_forest}\n R-squared: {r2_forest}\n")

# Save the best performing model
best_model = forest_model if r2_forest > r2_tree else tree_model
joblib.dump(best_model, 'best_sales_model.pkl')

# Customer Segmentation: Using K-Means Clustering
X_customers = customers_numeric

# Scale the data
scaler_customers = StandardScaler()
X_customers_scaled = scaler_customers.fit_transform(X_customers)

print("*************************************\nColumns used for seg Model (X):")
print(X_customers_scaled)
print("\n*************************************")

# Train the KMeans model
kmeans = KMeans(n_clusters=3, random_state=42)  # Assume 3 clusters for simplicity
kmeans.fit(X_customers_scaled)

# Save the clustering model and scaler
joblib.dump(kmeans, 'kmeans_model.pkl')
joblib.dump(scaler_customers, 'scaler_customers.pkl')

# Test the model (labels for each customer)
customer_clusters = kmeans.labels_
print(f"Customer Segments: {customer_clusters[:5]}")

import numpy as np

# Check the distribution of customers across clusters
unique, counts = np.unique(customer_clusters, return_counts=True)
print(dict(zip(unique, counts)))


# Define functions to load models and make predictions
def predict_sales():
    try:
        # Load the models
        sales_model = joblib.load('sales_model.pkl')
        scaler = joblib.load('scaler.pkl')

        # Get user input (numeric values)
        user_input = simpledialog.askstring("Input",
                                            "Enter numeric features separated by commas (e.g., feature1, feature2, ...):")
        input_data = [float(x) for x in user_input.split(',')]

        # Scale the input
        input_scaled = scaler.transform([input_data])

        # Predict sales
        prediction = sales_model.predict(input_scaled)
        messagebox.showinfo("Prediction", f"Predicted Sales Quantity: {prediction[0]}")

    except Exception as e:
        messagebox.showerror("Error", str(e))


def predict_segmentation():
    try:
        # Load the models
        kmeans = joblib.load('kmeans_model.pkl')
        scaler_customers = joblib.load('scaler_customers.pkl')

        # Get user input (numeric values)
        user_input = simpledialog.askstring("Input",
                                            "Enter numeric features separated by commas (e.g., feature1, feature2, ...):")
        input_data = [float(x) for x in user_input.split(',')]

        # Scale the input
        input_scaled = scaler_customers.transform([input_data])

        # Predict customer segment
        segment = kmeans.predict(input_scaled)
        messagebox.showinfo("Prediction", f"Predicted Customer Segment: {segment[0]}")

    except Exception as e:
        messagebox.showerror("Error", str(e))


# Create the GUI
root = tk.Tk()
root.title("ML Model Predictions")
root.geometry("600x400")  # Set a larger window size

# Customize the background color
root.configure(bg='#f0f4c3')  # Light green background for vibrancy

# Add a title label with a vibrant font
title_font = font.Font(family='Helvetica', size=20, weight='bold')
title_label = tk.Label(root, text="Machine Learning Predictions", font=title_font, bg='#f0f4c3', fg='#2e7d32')
title_label.pack(pady=20)

# Create buttons for each model prediction with vibrant colors
button_font = font.Font(family='Arial', size=14, weight='bold')

sales_button = tk.Button(root, text="Predict Sales", command=predict_sales,
                         font=button_font, bg='#81c784', fg='white', padx=20, pady=10)
sales_button.pack(pady=15)

segmentation_button = tk.Button(root, text="Predict Customer Segment", command=predict_segmentation,
                                font=button_font, bg='#4caf50', fg='white', padx=20, pady=10)
segmentation_button.pack(pady=15)

# Run the GUI loop
root.mainloop()