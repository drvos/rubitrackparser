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

can_ok($p, qw(as_html));
