source(output(
		OrderId as string,
		CustomerId as integer,
		Date as date
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> orders
source(output(
		SaleId as string,
		OrderId as string,
		ProductId as integer,
		Quantity as integer
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> sales
source(output(
		customer_id as integer,
		customer_number as integer,
		name as string,
		city as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	limit: 100,
	isolationLevel: 'READ_UNCOMMITTED',
	format: 'table') ~> customer
source(output(
		product_id as integer,
		product_number as integer,
		p_name as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	isolationLevel: 'READ_UNCOMMITTED',
	format: 'table') ~> product
orders, sales join(orders@OrderId == sales@OrderId,
	joinType:'inner',
	matchType:'exact',
	ignoreSpaces: false,
	broadcast: 'auto')~> join1
join1, customer lookup(CustomerId == customer_number,
	multiple: false,
	pickup: 'any',
	broadcast: 'auto')~> lookup1
lookup1, product lookup(ProductId == product_number,
	multiple: false,
	pickup: 'any',
	broadcast: 'auto')~> lookup2
lookup2 derive(Date = toInteger(toString(Date,'yyyyMMdd'))) ~> derivedColumn1
derivedColumn1 sink(allowSchemaDrift: true,
	validateSchema: false,
	input(
		countries_id as integer,
		customers_id as integer,
		products_id as integer,
		date_id as integer,
		order_id as integer,
		sales_id as integer,
		p_weight as integer,
		s_quantity as integer
	),
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	errorHandlingOption: 'stopOnFirstError',
	mapColumn(
		customers_id = customer_id,
		products_id = ProductId,
		date_id = Date,
		order_id = sales@OrderId,
		sales_id = SaleId,
		s_quantity = Quantity
	)) ~> sink1