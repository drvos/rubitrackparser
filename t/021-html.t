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
  <td>Pace:</td>
  <td>6:34 min/km</td>
  <td>Maximal:</td>
  <td>5:45 min/km</td>
</tr>
<tr align='right'>
  <td>&nbsp;</td>
  <td>&nbsp;</td>
  <td>Anstieg:</td>
  <td>45 m</td>
</tr>
<tr>
  <td colspan='4' align='right'>Bewölkt bei 1,0 ℃</td>
</tr>
";

###
use rtParser;

use_ok('rtParser');

my $p = rtParser->new( 'rtexportfile' => $exportfile );
isa_ok( $p, 'rtParser' );

can_ok($p, qw(as_html));
my $output = $p->as_html;
is($output, $html, 'HTML-Table') or diag explain diff(\$output, \$html);

