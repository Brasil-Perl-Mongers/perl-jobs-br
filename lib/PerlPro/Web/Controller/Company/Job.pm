package PerlPro::Web::Controller::Company::Job;
use Moose;
use namespace::autoclean;
use utf8;

BEGIN { extends 'Catalyst::Controller' }

sub base :Chained('/company/auth/requires_login') PathPart('') CaptureArgs(0) {
    my ( $self, $ctx ) = @_;

    $ctx->stash(
        current_model => 'DB::Job',
        company => $ctx->user->get_object->user_companies->first->get_column('company'),
    );
}

sub item : Chained('base') PathPart('job') CaptureArgs(1) {
    my ( $self, $ctx, $id ) = @_;

    my $item = $ctx->model->find($id);

    if ($item->get_column('company') ne $ctx->stash->{company}) {
        $ctx->detach('/forbidden');
    }

    $ctx->stash(
        id   => $id,
        item => $item,
    );
}

sub index :Chained('base') PathPart('my_jobs') Args(0) GET {
    my ( $self, $ctx ) = @_;

    my $company = $ctx->user->get_object->user_companies->first->company;
    my $search  = $company->get_my_jobs( { page => $ctx->req->params->{page} } );

    $ctx->stash(
        template     => 'company/my_jobs.tx',
        current_page => 'my_jobs',
        jobs         => $search->{items},
        pager        => $search->{pager},
    );
}

sub remove :Chained('item') PathPart('') Args(0) DELETE {
    my ( $self, $ctx ) = @_;

    my $item = $ctx->stash->{item};

    if (!$item) {
        # TODO: we could have a job_not_found action
        $ctx->detach('/not_found');
    }

    # TODO:
    # maybe avoid really deleting, and use some sort of flag
    # maybe even just set it as inactive
    $item->delete;

    $ctx->res->status(204);
}

sub add_job :Chained('base') PathPart('job/new') Does('DisplayExecute') Args(0) {
    my ( $self, $ctx ) = @_;

    my $uri = $ctx->req->uri;

    $ctx->stash(
        template        => 'company/add_or_update_job.tx',
        current_page    => 'add_job',
        form_action_uri => "$uri",
        is_update       => 0,
    );
}

sub add_job_display {
    my ( $self, $ctx ) = @_;

    my $fields = $ctx->stash->{fields} ||= {};

    my $company         = $ctx->model('DB::Company')->find($ctx->stash->{company});
    my $public_phone    = $company->company_phones->search({ is_public => 1 })->first;
    my $public_email    = $company->company_emails->search({ is_public => 1 })->first;
    my $public_location = $company->company_locations->search({ is_public => 1 })->first;

    $fields->{'job.create_or_update.address'} = $public_location ? $public_location->address : '';
    $fields->{'job.create_or_update.city'}    = $public_location ? $public_location->city : '';
    $fields->{'job.create_or_update.state'}   = $public_location ? $public_location->state : '';

    $fields->{'job.create_or_update.email'} = $public_email ? $public_email->email : '';
    $fields->{'job.create_or_update.phone'} = $public_phone ? $public_phone->phone : '';

    _flatten_attributes($fields);
}

sub add_job_execute {
    my ( $self, $ctx ) = @_;

    if (ref $ctx->req->params->{job}) {
        my $p = $ctx->req->params->{job}{create_or_update};
        $p->{company} = $ctx->stash->{company};
        $p->{status}  = 'active';
    }
}

sub update :Chained('item') PathPart('') Does('DisplayExecute') Args(0) GET POST {
    my ( $self, $ctx ) = @_;

    if (ref $ctx->req->params->{job}) {
        $ctx->req->params->{job}{create_or_update}{company} = $ctx->stash->{company};
    }

    my $uri = $ctx->req->uri;
    my $fields = $ctx->model->get_to_update($ctx->stash->{item});

    $ctx->stash(
        template            => 'company/add_or_update_job.tx',
        current_page        => 'my_jobs', # just to color something in the menu
        fields              => $fields,
        required_attributes => $fields->{'job.create_or_update.required_attributes'},
        desired_attributes  => $fields->{'job.create_or_update.desired_attributes'},
        form_action_uri     => "$uri",
        uri_to_redirect     => [ $self->action_for('update'), [ $ctx->stash->{id} ] ],
        is_update           => 1,
    );
}

sub update_display {
    my ( $self, $ctx ) = @_;

    _flatten_attributes($ctx->stash->{fields});
}

sub _flatten_attributes {
    my $f = shift;

    # the names are too long!
    my $d = 'job.create_or_update.desired_attributes';
    my $r = 'job.create_or_update.required_attributes';

    if ( $f->{$d} && ref $f->{$d} ) {
        $f->{$d} = join ',', @{ $f->{$d} };
    }
    if ( $f->{$r} && ref $f->{$r} ) {
        $f->{$r} = join ',', @{ $f->{$r} };
    }
}


__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding utf8

=head1 NAME

PerlPro::Web::Controller::Company::Job - Catalyst Controller

=head1 DESCRIPTION

Controller for a logged in user, from a company, to browse his own jobs and
manage them (CRUD).

=head1 METHODS

=head2 base

=head2 item

=head2 index

=head2 remove

=head2 add_job

=head2 update

=head1 AUTHOR

André Walker

=head1 LICENSE

This file is part of PerlPro.

PerlPro is free software: you can redistribute it and/or modify it under the
terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.
