#!/usr/bin/perl

=head1 purpose

Compare the list of country codes in our data file with the list
in our source directory. Fail any missing countries.

=cut

use Modern::Perl;
use Test::More;

my $datafile = "data/iso_3166_1.txt";

open my $df, "<", $datafile;
my @data = <$df>;
close $df;

plan tests => scalar @data;

foreach my $row (@data) {
    chomp $row;  
    my ($code, $name) = split /\|/, $row;
    ok(-f "png/" . lc $code . ".png", $name);
}

