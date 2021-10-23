use strict;
use warnings;
use v5.018;

use Test::More tests => 4;

use lib '../lib';

###
use rtParser;

use_ok('rtParser');

# Wandern
my $p = rtParser->new( 'rtexportfile' => 't/export/20210425-130133.html' );
isa_ok( $p, 'rtParser' );

can_ok($p, qw(activity));
is( $p->activity, 'Wandern', sprintf("activity: %s", $p->activity) );
