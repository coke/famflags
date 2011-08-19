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

my $sprite = GD::Image->new($sprite_width, $sprite_height);

my $row = 0;
my $col = 0;
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
</head>
<body style="background-color:#DDD">
END_HTML

foreach my $file (@icons) {
    open my $PNG, "<", $file;
    my $icon = GD::Image->newFromPng($PNG);

    my $x = $row*$icon_width;
    my $y = $col*$icon_height;

    $sprite->copyMerge($icon,$x,$y,0,0,$icon_width,$icon_height, 100);
    if ($col++ > $cols) {
        $row++;
        $col = 0;
    }
    $file =~ m{/(.*)\.png};
    my $code = $1;
    $x*=-1;
    $y*=-1;
    $css .= "\n.flag." . $code . "{background-position:" . $x . "px ". $y . "px}";
    $html .= "<span class=\"flag $code\">&nbsp;</span> $code<br>\n";
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


