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

done_testing;

