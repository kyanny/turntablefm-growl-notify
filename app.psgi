#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Request;

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);

    my $title = $req->param('title');
    (my $message = $req->param('message')) =~ s/\A:\s+(.*)\z/$1/;

    `growlnotify -m $message $title`;

    return ["200", ["Content-Type", "text/javascript"], []];
}
