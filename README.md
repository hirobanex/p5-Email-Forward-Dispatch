# NAME

Mremora - use ~/.forward plaggerable

# SYNOPSIS

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

# DESCRIPTION

Mremora is Email forward utility tool. 

# LICENSE

Copyright (C) Hiroyuki Akabane.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Hiroyuki Akabane <hirobanex@gmail.com>
