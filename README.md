[![Build Status](https://travis-ci.org/hirobanex/p5-Mremora.png?branch=master)](https://travis-ci.org/hirobanex/p5-Mremora) [![Coverage Status](https://coveralls.io/repos/hirobanex/p5-Mremora/badge.png?branch=master)](https://coveralls.io/r/hirobanex/p5-Mremora?branch=master)
# NAME

Email::Forward::Dispatch - use ~/.forward plaggerable

# SYNOPSIS

    # in /home/hirobanex/script.pl
    use Email::Forward::Dispatch;

    my $dispatcher = Email::Forward::Dispatch->new(
        is_forward_cb   => sub { ($_[1]->header('To') =~ /hirobanex\@gmail\.com/) ? 1 : 0 },
        forward_cb      => sub { print $_[1]->header('To') },
    );

    or 
    my $dispatcher = Email::Forward::Dispatch->new(
        mail      => scalar do {local $/; <STDIN>; },
        hooks_dir => "MyMailNotify::Hooks",
    );

    $dispatcher->run;



    #in /home/hirobanex/.forward
    "|exec /home/hirobanex/script.pl"

# DESCRIPTION

Email::Forward::Dispatch is Email forward utility tool. 

# LICENSE

Copyright (C) Hiroyuki Akabane.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Hiroyuki Akabane <hirobanex@gmail.com>
