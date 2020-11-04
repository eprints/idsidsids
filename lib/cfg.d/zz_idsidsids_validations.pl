$c->{validate_id}->{doi} = sub {
	my( $session, $value ) = @_;
	$value = "" unless defined $value;
        return EPrints::DOI->parse( $value, test => 1 );	
};

$c->{validate_id}->{issn} = sub {
        my ( $session, $value ) = @_;
        $value = "" unless defined $value;
	$value =~ s/[- ]//g;
	$value =~ s/^ISSN//i;
        return 0 unless $value =~ /^[0-9X]{8}$/i;
	my $weight = 8;
        my $sum = 0;
        for my $c (split //, $value) {
                last if $weight == 1;
                $sum += $weight-- * $c;
        }
        my $checkdigit = 11 - $sum % 11;
        $checkdigit = "X" if $checkdigit == 10;
        return $checkdigit eq substr( $value, -1 );
};

$c->{validate_id}->{isbn} = sub {
        my ( $session, $value ) = @_;
        $value = "" unless defined $value;
	$value =~ s/[- ]//g;
        $value =~ s/^ISBN//i;
	return 0 unless $value =~ /^[0-9X]{10,13}$/i;
	if ( length $value == 10 )
	{
		my $weight = 10;
		my $sum = 0;
		for my $c (split //, $value) {
			last if $weight == 1;
			$sum += $weight-- * $c;
		}
		my $checkdigit = $sum % 11;
		$checkdigit = "X" if $checkdigit == 10;
		return $checkdigit eq substr( $value, -1 );
	}
	else
	{
		my $count = 0;
                my $sum = 0;
                for ( my $c = 0; $c < length( $value ) - 1; $c++ )
		{
			my $product = substr( $value, $c, 1 );
			$product = $product * 3 if $c % 2 == 1;
                        $sum += $product;
                }
		my $checkdigit = 10 - $sum % 10;
		return $checkdigit == substr( $value, -1 );
	}
};

$c->{validate_id}->{pmcid} = sub { 
	my ( $session, $value ) = @_;
	$value = "" unless defined $value;
	return if $value =~ /^PMC[0-9]+$/i;
};

$c->{validate_id}->{pmid} = sub {
        my ( $session, $value ) = @_;
        $value = "" unless defined $value;
        return if $value =~ /^[0-9]+$/i;
};

$c->{validate_id}->{undefined} = sub {
	my ( $session, $value ) = @_;
        return if defined $value;
};	
