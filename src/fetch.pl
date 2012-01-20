#! /usr/bin/perl

use Modern::Perl;

=head1 fetch.pl

Pull ISO 3166-1 data from wikipedia.

=cut

my $url = "http://www.iso.org/iso/list-en1-semic-3.txt";

# previous site blocked LWP::Simple, too lazy to change it.

my $content;
{
    open(my $data, "curl $url |");
    local $/;
    $content = <$data>;
}

my @content = grep { ! /^\s+$/ && ! /ISO 3166-1/}
              map  {chomp; $_}
              split /\n/, $content;

say join("\n", @content);
