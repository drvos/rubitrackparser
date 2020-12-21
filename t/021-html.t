use strict;
use warnings;
use v5.018;

use Test::More tests => 4;
use Text::Diff;

use lib '../lib';

my $exportfile = 't/export/20201213-140543.html';
my $html = "
  <tr align='right'>
    <td>Distanz:</td>
    <td>14,08 km</td>
    <td>Dauer:</td>
    <td>1:32:35 hrs</td>
  </tr>
  <tr align='right'>
    <td>Herzfrequenz:</td>
    <td>142 bpm</td>
    <td>Kadenz:</td>
    <td>82 rpm</td>
  </tr>
  <tr align='right'>
    <td>Geschwindigkeit:</td>
    <td>9,1 km/h</td>
    <td>Anstieg:</td>
    <td>45 m</td>
  </tr>
  <tr align='right'>
    <td>Max. Geschwindigkeit:</td>
    <td>10,4 km/h</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan='4' align='right'>Bewölkt bei 1,0 ℃</td>
  </tr>";

###
use rtParser;

use_ok('rtParser');

my $p = rtParser->new( 'rtexportfile' => $exportfile );
isa_ok( $p, 'rtParser' );

can_ok($p, qw(as_html));
my $output = $p->as_html;
is($output, $html, 'HTML-Table') or diag explain diff(\$output, \$html);

