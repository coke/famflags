#! /usr/bin/perl

use Modern::Perl;

=head1 fetch.pl

Pull ISO 3166-1 data from wikipedia.

=cut

my $url = "http://en.wikipedia.org/wiki/ISO_3166-1";

# Wikipedia blocks LWP::Simple...

my $content;
{
    open(my $data, "curl $url |");
    local $/;
    $content = <$data>;
}

$content =~ s{.*?Officially assigned code}{}smi;
$content =~ s{.*?(<table)}{$1}smi;
$content =~ s{(</table>).*}{$1}smi;

my @rows = split /<tr>/, $content;

my @data = ();
foreach my $row (@rows) {
    my @cells = split /<td>/, $row;
    my $rd = [];
    foreach my $cell (@cells) {
        chomp $cell;
        $cell =~ s/<[^>]*>//g;
        $cell =~ s/&#160;//g;
        push $rd, $cell;
    }
    push @data, $rd;
}

foreach my $row (@data) {
    my $code = $row->[2];
    my $name = $row->[1];
    next unless $code;
    say "$code|$name";
}
