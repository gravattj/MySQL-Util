package MySQL::Util::Lite::ForeignKey;

our $VERSION = '0.01';

use Modern::Perl;
use Moose;
use namespace::autoclean;
use Method::Signatures;
use Data::Printer alias => 'pdump';
use MySQL::Util::Lite::ForeignKeyColumn;

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

method get_columns {

	my $aref = $self->_util->get_constraint(
		name  => $self->name
	);

	my @cols;

	foreach my $col (@$aref) {
		push @cols, MySQL::Util::Lite::ForeignKeyColumn->new(
			name        => $col->{COLUMN_NAME},
			table_name  => $col->{TABLE_NAME},
			schema_name => $col->{CONSTRAINT_SCHEMA},
			parent_column_name => $col->{REFERENCED_COLUMN_NAME},
			parent_table_name  => $col->{REFERENCED_TABLE_NAME},
			parent_schema_name => $col->{REFERENCED_TABLE_SCHEMA},
		);

	}

	return @cols;
}

1;
