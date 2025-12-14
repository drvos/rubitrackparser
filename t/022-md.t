use strict;
use warnings;
use v5.018;
use utf8;

use Test::More tests => 4;
use Text::Diff;

use lib '../lib';

my $exportfile = 't/export/20201213-140543.html';
my $md = '
|Attribut|Wert|
|:---|---:|
|Distanz|14,08 km|
|Dauer|1:32:35 hrs|
|Herzfrequenz|142 bpm|
|Kadenz|82 rpm|
|Pace|6:34 min/km|
|Maximal|5:45 min/km|
|Anstieg|45 m|
|Wetter|Bewölkt|
|Temperatur|1,0 ℃|
';

###
use rtParser;

use_ok('rtParser');

my $p = rtParser->new( 'rtexportfile' => $exportfile );
isa_ok( $p, 'rtParser' );

can_ok($p, qw(as_markdown));
my $output = $p->as_markdown;
is($output, $md, 'Markdown-Table') or diag explain diff(\$output, \$md);

