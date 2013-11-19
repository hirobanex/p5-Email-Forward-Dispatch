package Mremora;
use 5.008005;
use strict;
use warnings;
use Email::MIME;
use Module::Pluggable::Object;

our $VERSION = "0.02";

sub new {
    my ($class,%args) = @_;

    unless ($args{hooks_dir}) {
        $args{check_cb}   or die 'you must register check_cb!';
        $args{forward_cb} or die 'you must register forward_cb!';

        {
            my $default_class = "Mremora::Hooks::Default";
            no strict 'refs'; ## no critic.
            no warnings 'redefine';
            push @{"$default_class\::ISA"}, 'Mremora::Hooks';
            *{"$default_class\::check"}   = sub { my ($class, $parsed) = @_;  $args{check_cb}->($default_class,$parsed); };
            *{"$default_class\::forward"} = sub { my ($class, $parsed) = @_;  $args{forward_cb}->($default_class,$parsed); };
        }
    }

    my $mail = $args{mail} || do {local $/; <STDIN>; } || die 'you must set mail option or STDIN !';

    my $self = bless +{
        email     => Email::MIME->new($mail),
        hooks_dir => $args{hooks_dir} || 'Mremora::Hooks',
    }, $class;

}

sub run {
    my ($self) = @_;

    my @hooks = Module::Pluggable::Object->new(
        require     => 1,
        search_path => $self->{hooks_dir},
    )->plugins;

    for my $hook (@hooks) {
        next unless $hook->check($self->{email});

        $hook->forward($self->{email});
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Mremora - use ~/.forward plaggerable

=head1 SYNOPSIS

    # in /home/hirobanex/script.pl
    use Mremora;

    my $dispatcher = Mremora->new(
        check_cb   => sub { ($_[1]->header('To') =~ /hirobanex\@gmail\.com/) ? 1 : 0 },
        forward_cb => sub { print $_[1]->header('To') },
    );

    or 

    my $dispatcher = Mremora->new(
        mail      => scalar do {local $/; <STDIN>; },
        hooks_dir => "MyMailNotify::Hooks",
    );

    $dispatcher->run;


    #in /home/hirobanex/.forward
    "|exec /home/hirobanex/script.pl"

=head1 DESCRIPTION

Mremora is Email forward utility tool. 

=head1 LICENSE

Copyright (C) Hiroyuki Akabane.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Hiroyuki Akabane E<lt>hirobanex@gmail.comE<gt>

=for stopwords plaggerable

=cut

