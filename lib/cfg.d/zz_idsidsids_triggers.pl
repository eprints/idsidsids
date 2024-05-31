# To prevent citations, exports etc. from breaking, populate the default  id_number'
# field using a suitable value from the new 'ids' field
# If multiple IDs of the same type are permitted first ID fo type with the highest 
# priority will be used for in id_number field.
$c->add_dataset_trigger( 'eprint', EPrints::Const::EP_TRIGGER_BEFORE_COMMIT, sub
{
        my( %args ) = @_;
        my( $repo, $eprint, $changed ) = @args{qw( repository dataobj changed )};

	# trigger is global - check that current repository actually has idsidsids enabled
        return unless $eprint->dataset->has_field( 'ids' );

	# if this is an existing record, or a new record that has been imported, initialise
        # the 'ids' field first
	my $idps = $repo->config( 'id_priorities' );
        if( !$changed->{ids} && !$eprint->is_set( "ids" ) && ( $eprint->is_set( "id_number" ) || $eprint->is_set( "isbn" ) || $eprint->is_set( "issn" ) ) )
        {
		my @ids = ();
		if ( $eprint->is_set( "id_number" ) )
		{
			my $id_number = $eprint->value( "id_number" );
			foreach my $id_type (sort { $idps->{$b} <=> $idps->{$a} } keys %{$idps}) 
			{
				if ( defined $c->{validate_id}->{$id_type} && $c->{validate_id}->{$id_type}( $repo, $id_number ) )
				{
					push @ids, { id => $id_number, id_type => $id_type };
					last;	
				}
			}
		}
		if ( $eprint->is_set( "isbn" ) )
                {
			push @ids, { id => $eprint->value( "isbn" ), id_type => 'isbn' };
		}
		if ( $eprint->is_set( "issn" ) )
                {	
			push @ids, { id => $eprint->value( "issn" ), id_type => 'issn' };
                }
		
		$eprint->set_value( "ids", \@ids ) if scalar @ids;
        }
	else 
	{
	        my $ids = $eprint->get_value( 'ids' );
        	return unless scalar @{$ids} > 0;

        	my $id_id = undef;
	        my $id_type = undef;
		my $id_note = undef;
        	foreach my $id (@{$ids})
	        {
			$id->{id_type} = "undefined" unless defined $id->{id_type};
        	        if ( defined $id->{id} && defined $idps->{$id->{id_type}} && ( !defined $id_type || !defined $idps->{$id_type} || $idps->{$id->{id_type}} > $idps->{$id_type} ) )
                	{
                        	$id_type = $id->{id_type};
	                        $id_id = $id->{id};
				$id_note = $id->{id_note};
        	        }
			if ( defined $id->{id} && $id->{id_type} eq "issn" )
			{
				my $issn = $id->{id};
				$issn .= " (" . $id->{id_note} . ")" if defined $id->{id_note};
				$eprint->set_value( "issn", $issn );
			}

			if ( defined $id->{id} &&  $id->{id_type} eq "isbn" )
			{
				my $isbn = $id->{id};
                                $isbn .= " (" . $id->{id_note} . ")" if defined $id->{id_note};
				$eprint->set_value( "isbn", $isbn );
			}

        	}
	        if ( defined $id_id )
		{
			my $id_number = $id_id;
			$id_number = $id_type . ":" . $id_number if defined $id_type && $id_type ne "undefined";
			$id_number .= " (" . $id_note . ")" if defined $id_note;
			$eprint->set_value( "id_number", $id_number );
		}
	}
}, priority => 100 );

# Validation - ensure that the format of IDs used are correct.
$c->add_trigger( EPrints::Const::EP_TRIGGER_VALIDATE_FIELD, sub
{
        my( %args ) = @_;
        my( $repo, $field, $eprint, $value, $problems ) = @args{qw( repository field dataobj value problems )};

        return unless $field->name eq "ids_id";
	my $parent = $field->get_property( "parent" );
	my $validations = $repo->config( "validate_id" );

	return unless defined $validations;
	for( @{ $eprint->value( "ids" ) } )
        {
		my $id_value = $_->{id};
		my $id_type = $_->{id_type};		
		if ( defined $validations->{$id_type} )
		{
			if ( !$validations->{$id_type}( $repo, $id_value ) )
			{
		               	my $fieldname = $repo->xml->create_element( "span", class=>"ep_problem_field:".$field->get_name );
	               		$fieldname->appendChild( $parent->render_name( $repo ) );
		               	push @$problems, $repo->html_phrase( "validate:idsidsids:invalid_id_format",
        		                fieldname => $fieldname,
                		        id_type => $repo->html_phrase( "eprint_fieldopt_ids_id_type_" . $id_type ),
					id_value => $repo->make_text( $id_value ),
				);
			}
		}
        }
}, priority => 100 );

# Validation - ensure that only one of each type of date (doi, pmid, etc). has been entered.
# Uncomment below to limit IDs to one per type.
#$c->add_trigger( EPrints::Const::EP_TRIGGER_VALIDATE_FIELD, sub
#{
#       my( %args ) = @_;
#       my( $repo, $field, $eprint, $value, $problems ) = @args{qw( repository field dataobj value problems )};
#
#       return unless $field->name eq "ids_id_type";
#
#       my %seen;
#       for( @{ $value } )
#       {
#               next unless defined $_;
#               $seen{$_}++;
#       }
#
#       for( keys %seen )
#       {
#               if( $seen{$_} > 1 )
#               {
#                       my $parent = $field->get_property( "parent" );
#                       my $fieldname = $repo->xml->create_element( "span", class=>"ep_problem_field:".$parent->get_name );
#                       $fieldname->appendChild( $parent->render_name( $repo ) );
#                       push @$problems, $repo->html_phrase( "validate:idsidsids:duplicate_id_type",
#                               fieldname => $fieldname,
#                               id_type => $repo->html_phrase( "eprint_fieldopt_ids_id_type_$_" ),
#                       );
#               }
#       }
#}, priority => 200 );

