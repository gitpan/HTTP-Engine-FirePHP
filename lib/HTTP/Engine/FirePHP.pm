package HTTP::Engine::FirePHP;

use strict;
use warnings;
use HTTP::Headers::Fast;
use HTTP::Engine::Response;
use HTTP::Engine::FirePHP::Dispatcher;

our $VERSION = '0.01';

unless (grep { $_ eq 'HTTP::Headers' } @HTTP::Headers::Fast::ISA) {
    unshift @HTTP::Headers::Fast::ISA, 'HTTP::Headers';
}

sub HTTP::Engine::Response::fire_php {
    my $self = shift;

    unless (defined $self->{fire_php}) {
        $self->{fire_php} = HTTP::Engine::FirePHP::Dispatcher->new(
            $self->headers
        );
    }

    $self->{fire_php};
}

1;

__DATA__

=head1 NAME

HTTP::Engine::FirePHP - Log to FirePHP from within HTTP::Engine

=head1 SYNOPSIS

    use HTTP::Engine::Response;
    use HTTP::Engine::FirePHP;

    sub request_handler {
        my $req = shift;
        my $res = HTTP::Engine::Response->new;
        # ...
        $res->fire_php->log('foo');
        # ...
        $res;
    }

=head1 DESCRIPTION

FirePHP is a Firebug plugin which enables you to log to your Firebug Console
by sending certain HTTP headers in the HTTP response. FirePHP is not just
useful for PHP, though; any server-side application that can manipulate HTTP
headers can log to Firebug.

The FirePHP response headers use the Wildfire protocol. The CPAN module
L<FirePHP::Dispatcher> can generate these headers.

This module then integrates L<FirePHP::Dispatcher> with L<HTTP::Engine>. By
simply using this module, L<HTTP::Engine::Response> gets a C<fire_php()>
accessor through which you can log to FirePHP.

=head1 METHODS

=over 4

=item fire_php()

    my $res = HTTP::Engine::Response->new;
    $res->fire_php->log('foo');

This method is placed into the L<HTTP::Engine::Response> class. The first time
you access it, a new L<HTTP::Engine::FirePHP::Dispatcher> object is created.
You can use all logging methods of L<FirePHP::Dispatcher>; please refer to
that module's manpage.

Note that - despite what it says in L<FirePHP::Dispatcher> - you don't have to
call C<finalize()>; this is done automatically each time something is logged.

When you load the response into Firefox, open the Firebug Console and you will
find the logged messages there.

When you restart the HTTP::Engine-based server, be sure to do a shift-reload
of the relevant page in Firefox; this ensures that headers aren't cached. If
you don't do this, you might see remnant headers from previous responses.

=back

=head1 CAUTION

This module monkeypatches L<HTTP::Engine::Response>, so it's not ideal
encapsulation. Also, L<FirePHP::Dispatcher> expects to work with a
L<HTTP::Headers> object, but L<HTTP::Engine::Response> uses
L<HTTP::Headers::Fast>, so this module also munges the latter module's
inheritance to make it look like the right class.

=head1 SEE ALSO

=over 4

=item Firebug: L<http://www.firephp.org/>

=item Wildfire protocol: L<http://www.firephp.org/Wiki/Reference/Protocol>

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

The development version lives at
L<http://github.com/hanekomu/http-engine-firephp/>. Instead of sending
patches, please fork this project using the standard git and github
infrastructure.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

