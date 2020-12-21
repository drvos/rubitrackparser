use strict;
use warnings;
use v5.018;

use Test::More 'no_plan';

use lib '../lib';

my $exportfile = 't/export/20201213-140543.html';

###
use rtParser;

use_ok('rtParser');

my $p = rtParser->new( 'rtexportfile' => $exportfile );
isa_ok( $p, 'rtParser' );

my $msg = sprintf("%s am %s um %s Uhr", $p->activity, $p->date, $p->time);
is($msg, 'Laufen am 13.12.2020 um 14:05 Uhr', 'Headline');

can_ok($p, qw(as_html));

