import pandas as pd

with open(r'C:\Users\hp\Desktop\depi\final project\sales.json', encoding='utf-8') as inputfile:
        df = pd.read_json(inputfile)

df.to_csv('sales.csv', encoding='utf-8', index=False)