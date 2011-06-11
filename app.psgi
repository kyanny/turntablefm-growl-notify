#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Request;
use Cwd;
use File::Spec;

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);

    my $title = $req->param('title');
    (my $message = $req->param('message')) =~ s/\A:\s+(.*)\z/$1/;
    my $image = File::Spec->catfile(getcwd, 'turntablefm.jpg');

    `growlnotify --image $image -m '$message' '$title'`;

    return ["200", ["Content-Type", "text/javascript"], []];
}
