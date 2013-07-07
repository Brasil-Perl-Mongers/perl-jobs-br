use utf8;
package PerlPro::Schema::Result::UserCompany;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PerlPro::Schema::Result::UserCompany

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::EncodedColumn>

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("EncodedColumn", "InflateColumn::DateTime");

=head1 TABLE: C<company.user_company>

=cut

__PACKAGE__->table("company.user_company");

=head1 ACCESSORS

=head2 user

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 company

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "company",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user>

=item * L</company>

=back

=cut

__PACKAGE__->set_primary_key("user", "company");

=head1 RELATIONS

=head2 company

Type: belongs_to

Related object: L<PerlPro::Schema::Result::Company>

=cut

__PACKAGE__->belongs_to(
  "company",
  "PerlPro::Schema::Result::Company",
  { name_in_url => "company" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<PerlPro::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "PerlPro::Schema::Result::User",
  { login => "user" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-07-07 00:28:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zlmCMc5USElO88Gwn95nkw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
