$c->{render_id}->{doi} = sub {
	my( $session, $value ) = @_;	
	return EPrints::Extras::render_possible_doi( $session, undef, $value );
};

$c->{render_id}->{isbn} = sub {
        my( $session, $value ) = @_;

	return unless defined $value and $value ne "";
	my $label = $value;
	$label = "ISBN $value" if $label !~ /ISBN/gi;
        $value =~ s/[^\dX]//gi;	
	$value = uc $value;
	return $session->make_text( $label ) unless $value =~ /^[0-9X]{10,13}$/;	
        my $link = $session->render_link( "https://isbnsearch.org/isbn/" . $value, "_blank" );
        $link->appendChild( $session->make_text( $label ) );
        return $link;
};

$c->{render_id}->{issn} = sub {
        my( $session, $value ) = @_;

	return unless defined $value and $value ne "";
        my $label = $value;
        $label = "ISSN $value" if $label !~ /ISSN/gi;
        $value =~ s/[^\dX]//gi;
        $value = uc $value;
	$value = substr( $value, 0, 4 ) . "-" . substr( $value, 4, 4 );
        return $session->make_text( $label ) unless $value =~ /^[0-9]{4}-[0-9X]{4}$/;
        my $link = $session->render_link( "https://portal.issn.org/resource/ISSN/" . $value, "_blank" );
        $link->appendChild( $session->make_text( $label ) );
        return $link;
};

$c->{render_id}->{issn_print} = $c->{render_id}->{issn};
$c->{render_id}->{issn_online} = $c->{render_id}->{issn};

$c->{render_id}->{pmid} = sub {
        my( $session, $value ) = @_;

	return unless defined $value and $value ne "";
        my $label = $value;
        $label = "PMID $value" if $label !~ /PMID/gi;	
	$value =~ s/[^\d]//gi;
	my $link = $session->render_link( "https://pubmed.ncbi.nlm.nih.gov/" . $value, "_blank" );
        $link->appendChild( $session->make_text( $label ) );
        return $link;
};

$c->{render_id}->{pmcid} = sub {
        my( $session, $value ) = @_;

	return unless defined $value and $value ne "";
        my $label = $value;
        my $link = $session->render_link( "https://www.ncbi.nlm.nih.gov/pmc/articles/" . $value, "_blank" );
	return $session->make_text( $label ) unless $value =~ /^PMC[0-9]+$/;
        $link->appendChild( $session->make_text( $label ) );
        return $link;
};

$c->{render_ids_with_types} = sub {
	my( $session, $field, $values, $alllangs, $nolink, $object ) = @_;

	my $ul = $session->make_element( "ul", "class" => "ep_ids_list" );
	foreach my $value ( @{$values} )
	{
        	my $render_func = $session->config( 'render_id', $value->{id_type} );
		my $rendered_id = &$render_func( $session, $value->{id} );
		if ( defined $rendered_id )
		{
			my $li = $session->make_element( "li" );
			$li->appendChild( $rendered_id );
			$ul->appendChild( $li );
		}
	}
	return $ul;
};

