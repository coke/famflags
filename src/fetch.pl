use v6;

use LWP::Simple;

# Pull ISO 3166-1 data from wikipedia.
# Text is available under the Creative Commons Attribution-ShareAlike License 

sub MAIN() {

    # Extract data from wikipedia.
    my $url = "http://en.wikipedia.org/wiki/ISO_3166-2";
    my $response = LWP::Simple.get($url);

    my @row;
    my @data;
    for $response.lines -> $_ {
        if / '<th>Country name</th>' / ff / '</table>' / {
            if / '</tr>' / {
                if +@row {
                    @data.push([@row]);
                }
                @row = ();
            }
            if / '<td>' .*?  '<a' <-[>]>* '>' (.+?) '</a>' .* '</td>'/ {
                @row.push(~$/[0]);
            }
            
            # only process the first table. 
            last if / '</table>' /;
        }
    }

    for @data.sort:{$_[1].uc} -> @row {
        say @row[1].uc ~ ";" ~ @row[0];
    }
}
