# Add a new compound field called 'dates' to allow multiple dates to be entered against a record
$c->add_dataset_field( "eprint",
	{
		name => 'ids',
		type => 'compound',
		multiple => 1,
		fields => [
			{ 
				sub_name => 'id',
				type => 'id',
			},
			{
				sub_name => 'id_type',
				type => 'set',
				options => [qw( doi isbn issn pmid pmcid )],
			},
			{
				sub_name => 'id_note',
				type => 'text',
				maxlength => 32,
			},
		],
		render_value => 'render_ids_with_types',
		input_boxes => 1
	}
);



$c->{id_priorities} = {
	doi => 1000,
	isbn => 800,
	issn => 600,
	pmid => 500,
	pmcid => 400,
	undefined => 0,
};
