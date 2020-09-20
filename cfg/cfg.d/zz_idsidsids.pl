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
        issn_print => 800,
	issn_online => 750,
	issn => 700,
        isbn => 600,
	pmcid => 400,
	pmid => 300,
};
