use strict;
use warnings;
use utf8;
use Test::More;
use Mremora;
use Test::Output;

my $fname = "./t/sample_mail.txt";
open my $fh, '<', $fname or die "$fname: $!";
my $mail = do {local $/; <$fh>; };

subtest 'callback interface' => sub {
    
    my $dispatcher = Mremora->new(
            mail       => $mail,
            check_cb   => sub { ($_[1]->header('To') =~ /hirobanex\@gmail\.com/) ? 1 : 0 },
            forward_cb => sub { print $_[1]->header('To') },
    );

    stdout_like {$dispatcher->run} qr/gmail/,;
};

subtest 'hook class name diff' => sub {
    
    my @hooks1 = Mremora->new(
            mail       => $mail,
            check_cb   => sub { 0 },
            forward_cb => sub { 0 },
    )->fetch_hooks;
    
    my @hooks2 = Mremora->new(
            mail       => $mail,
            check_cb   => sub { 1 },
            forward_cb => sub { 1 },
    )->fetch_hooks;

    isnt $hooks1[0], $hooks2[0];
};

done_testing;

