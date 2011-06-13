#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Request;
use Cwd;
use File::Spec;
use Cocoa::Growl ':all';
use AnyEvent;
use AnyEvent::Impl::NSRunLoop;

my $cv = AnyEvent->condvar;

sub usage {
    print "!! Growl not installed or not running !!\n";
}

sub register {
    growl_register(
        app => 'Turntable.fm growl notify',
        icon => File::Spec->catfile(getcwd(), 'icon.jpg'),
        notifications => [qw(NewChatMessage)],
    );
}

sub notify {
    my ($title, $message) = @_;
    growl_notify(
        name => 'NewChatMessage',
        title => $title,
        description => $message,
        on_click => sub {
            `open -a Firefox`;
            $cv->send;
        },
    );
}

usage() && exit(1) unless growl_installed();
usage() && exit(1) unless growl_running();

register();

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);

    my $title = $req->param('title');
    my $message = $req->param('message');
    notify($title, $message);

    return ["200", ["Content-Type", "text/javascript"], []];
}
