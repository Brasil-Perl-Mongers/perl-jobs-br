package PerlPro::Web;
use Moose;
use namespace::autoclean;
use utf8;

use Catalyst::Runtime 5.90042;

# we don't use Unicode::Encoding because it's core since 5.90042
use Catalyst qw/
    ConfigLoader
    Static::Simple

    Params::Nested

    Session
    Session::State::Cookie
    Session::Store::File

    Authentication
    Authorization::Roles
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    encoding => 'UTF-8',
);

__PACKAGE__->setup();

1;

=encoding utf8

=head1 NAME

PerlPro::Web - Catalyst based application

=head1 SYNOPSIS

    script/perlpro_web_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<PerlPro::Web::Controller::Root>, L<Catalyst>

=head1 AUTHOR

André Walker

=head1 LICENSE

This file is part of PerlPro.

PerlPro is free software: you can redistribute it and/or modify it under the
terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.
