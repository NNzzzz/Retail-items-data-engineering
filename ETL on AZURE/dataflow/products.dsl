source(output(
		ProductId as integer,
		Name as string,
		ManufacturedCountry as string,
		WeightGrams as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> source1
source1 sink(allowSchemaDrift: true,
	validateSchema: false,
	input(
		product_id as integer,
		product_number as integer,
		p_name as string
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
		product_number = ProductId,
		p_name = Name
	)) ~> sink1