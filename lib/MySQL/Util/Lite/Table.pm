package MySQL::Util::Lite::Table;

our $VERSION = '0.01';

use Modern::Perl;
use Moose;
use namespace::autoclean;
use Method::Signatures;
use Data::Printer alias => 'pdump';
use MySQL::Util::Lite::ForeignKey;
use MySQL::Util::Lite::Column;

has name => (
	is       => 'ro',
	isa      => 'Str',
	required => 1,
);

has schema_name => (
	is       => 'ro',
	isa      => 'Str',
	required => 1,
);

has _util => (
	is       => 'ro',
	isa      => 'MySQL::Util',
	required => 1,
);

method get_parent_tables {

	my %seen;
	my @ret;
	my @fks = $self->get_foreign_keys;

	foreach my $fk (@fks) {
		foreach my $col ( $fk->get_columns ) {

			my $fq_table_name = sprintf( "%s.%s",
				$col->parent_schema_name, $col->parent_table_name );

			if ( !$seen{$fq_table_name} ) {
				push @ret,
				  MySQL::Util::Lite::Table->new(
					name        => $col->parent_table_name,
					schema_name => $col->parent_schema_name,
					_util       => $self->_util
				  );
			}

			$seen{$fq_table_name}++;
		}
	}
	
	return @ret;
}

method get_foreign_keys {

	my $fks_href = $self->_util->get_fk_constraints( $self->name );
	my @fks;

	foreach my $fk_name ( keys %$fks_href ) {
		push @fks,
		  MySQL::Util::Lite::ForeignKey->new(
			name        => $fk_name,
			table_name  => $self->name,
			schema_name => $self->schema_name,
			_util       => $self->_util
		  );
	}

	return @fks;
}

method has_parents {

	my @parents = $self->get_parent_tables;
	if (@parents) {
		return 1;	
	}		
	
	return 0;
}

method get_column (Str :$name) {

	my @cols = $self->get_columns;
	foreach my $col (@cols) {
		if ( $col->name eq $name ) {
			return $col;
		}
	}
}

method get_columns (Bool :$exclude_autoinc = 0) {

	my @cols;
	my $aref = $self->_util->describe_table( $self->name );
	foreach my $col (@$aref) {
		
		my $new = MySQL::Util::Lite::Column->new(
			name        => $col->{FIELD},
			table_name  => $self->name,
			schema_name => $self->schema_name,
			key => $col->{KEY},
			default     => $col->{DEFAULT},
			type        => $col->{TYPE},
			is_null        => $col->{NULL} =~ /^yes$/i ? 1 : 0,
			is_autoinc     => $col->{EXTRA} =~ /auto_increment/i ? 1 : 0,
		);

		if ($exclude_autoinc and $new->is_autoinc) {
			next;
		}
		
		push @cols, $new;
	}

	return @cols;
}

1;
