use strict;
use warnings;
use v5.018;

use Test::More tests => 4;
use Text::Diff;

use lib '../lib';

my $exportfile = 't/export/20201213-140543.html';
###
use rtParser;

use_ok('rtParser');

my $p = rtParser->new( 'rtexportfile' => $exportfile );
isa_ok( $p, 'rtParser' );

can_ok($p, qw(activity location date));
my $msg = sprintf("%s in %s am %s", $p->activity, $p->location, $p->date);
is($msg, 'Laufen in Templin, Stadtseerunde am 13.12.2020', 'Headline');

can_ok($p, qw(title));
is($p->title, 'Laufen in Templin, Stadtseerunde am 13.12.2020', 'Title');

