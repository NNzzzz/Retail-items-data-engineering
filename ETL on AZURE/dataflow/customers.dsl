source(output(
		CustomerId as integer,
		Active as string,
		Name as string,
		Address as string,
		City as string,
		Country as string,
		Email as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	inferDriftedColumnTypes: true,
	limit: 100,
	ignoreNoFilesFound: false) ~> source1
source1 sink(allowSchemaDrift: true,
	validateSchema: false,
	input(
		customer_id as integer,
		customer_number as integer,
		name as string,
		city as string
	),
	deletable:false,
	insertable:true,
	updateable:false,
	upsertable:false,
	format: 'table',
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	saveOrder: 1,
	errorHandlingOption: 'stopOnFirstError',
	mapColumn(
		name = Name,
		city = City,
		customer_number = CustomerId
	)) ~> sink1