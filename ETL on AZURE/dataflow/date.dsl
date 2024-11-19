source(output(
		OrderId as string,
		CustomerId as string,
		Date as date
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> orders
aggregate1 derive(Date_key = toInteger(toString(Date,'yyyyMMdd')),
		year = year(Date),
		Month = month(Date),
		day = dayOfMonth(Date)) ~> derivedColumn1
orders select(mapColumn(
		Date
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> select1
select1 aggregate(groupBy(Date),
	Date_ = count(Date)) ~> aggregate1
derivedColumn1 sink(allowSchemaDrift: true,
	validateSchema: false,
	input(
		date_id as date,
		year as integer,
		month as integer,
		day as integer
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
		date_id = Date_key,
		year,
		month = Month,
		day
	)) ~> sink1