#! /usr/bin/perl

use Modern::Perl;

use GD;

=head1 sprite.pl

Generates a CSS sprite using all the images from the png directory.

=cut

my $build_dir     = "build";
my $target_sprite = "flags.png";
my $target_css    = "flags.css";
my $target_html   = "index.html";

my $site_url = "https://github.com/coke/famflags";
my $VERSION  = "0.9";

my $icon_height = 11;
my $icon_width  = 16;
my @icons = <png/*.png>;

# Make the dimensions square-ish. Makes it easier to preview the sprite.
my $num_icons = scalar @icons;
my $cols = int sqrt $num_icons;
my $rows = int ($num_icons / $cols + 1 );

my $sprite_width  = $cols * $icon_width;
my $sprite_height = $rows * $icon_height;

GD::Image->trueColor(1);
my $sprite = GD::Image->new($sprite_width, $sprite_height);
$sprite->alphaBlending(0);
$sprite->saveAlpha(1);

my $css = <<"END_CSS";
/* $site_url ($VERSION) */
.flag{
float:left;
margin: 5px 5px 0 0;
width:${icon_width}px;
height:${icon_height}px;
background:url(${target_sprite}) no-repeat;
}
END_CSS

my $html = <<"END_HTML";
<!DOCTYPE html>
<!-- $site_url ($VERSION) -->
<head>
<link rel="stylesheet" href="flags.css">
<style type="text/css">.country{float:left;width:200px;height:35px;padding:5px;}</style>
</head>
<body style="background-color:#EEE">
<h1>Sample of all ISO 3166-1 country flags.</h1>
<div style="padding-bottom:10px;"><em>And some extras.</em></div>
END_HTML

my $datafile = "data/iso_3166_1.txt";

open my $df, "<", $datafile;

my %countries;
foreach my $row (<$df>) {
    chomp($row);
    my ($code, $country) = split /\|/, $row;
    $countries{$code} = $country;
}
close $df;

my $row = 0;
my $col = 0;
foreach my $file (@icons) {
    open my $PNG, "<", $file;
    my $icon = GD::Image->newFromPng($PNG);

    my $x = $row*$icon_width;
    my $y = $col*$icon_height;

    $sprite->copy($icon,$x,$y,0,0,$icon_width,$icon_height);
    if ($col++ > $cols) {
        $row++;
        $col = 0;
    }
    $file =~ m{/(.*)\.png};
    my $code = $1;
    $x*=-1;
    $y*=-1;
    $css .= "\n.flag." . $code . "{background-position:" . $x . "px ". $y . "px}";
    $html .= "<div class=\"country\"><span class=\"flag $code\">&nbsp;</span>";
    if (exists $countries{uc $code}) {
        $html .= $countries{uc $code} . " (" . uc $code . ")";
     } else {
        $html .= $code;
     }
     $html .= "</div>\n";
}

$html .= "</body></html>";

open my $sprite_png, ">", $build_dir . "/" . $target_sprite;
binmode $sprite_png;
print   {$sprite_png} $sprite->png(9);
close   $sprite_png;

open my $css_file, ">", $build_dir . "/" . $target_css;
print   {$css_file} $css;
close   $css_file;

open my $html_file, ">", $build_dir . "/" . $target_html;
print   {$html_file} $html;
close   $html_file;


