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
				required => 1
			},
			{
				sub_name => 'id_type',
				type => 'set',
				options => [qw( doi isbn issn issn_print issn_online pmid pmcid )],
				required => 1
			},
		],
		render_value => 'render_ids_with_types',
		input_boxes => 1
	}
);



$c->{id_priorities} = {
	doi => 1000,
        isbn => 800,
	pmcid => 600,
	pmid => 500,
	issn_print => 400,
        issn_online => 350,
        issn => 300,
};
