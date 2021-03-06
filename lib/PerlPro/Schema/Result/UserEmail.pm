use utf8;
package PerlPro::Schema::Result::UserEmail;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PerlPro::Schema::Result::UserEmail

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

=head1 TABLE: C<user_email>

=cut

__PACKAGE__->table("user_email");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'perlpro.user_email_id_seq'

=head2 user

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 email

  data_type: 'text'
  is_nullable: 0

=head2 is_main_address

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "perlpro.user_email_id_seq",
  },
  "user",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "email",
  { data_type => "text", is_nullable => 0 },
  "is_main_address",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<user_email_email_key>

=over 4

=item * L</email>

=back

=cut

__PACKAGE__->add_unique_constraint("user_email_email_key", ["email"]);

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-08-15 14:19:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:w6rtAM49lsDq+EnhnvT6MQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
