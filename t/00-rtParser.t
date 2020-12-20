use strict;
use warnings;
use v5.024;

use Test::More 'no_plan';

use lib '../lib';

###
use rtParser;

use_ok('rtParser');

my $p = rtParser->new( 'rtexportfile' => 't/20201213-140543.html' );
isa_ok( $p, 'rtParser' );

can_ok($p, 'rtexportfile');
is( $p->rtexportfile, 't/20201213-140543.html', sprintf("Get filename RubiTrackExportfile: %s", $p->rtexportfile) );

#
# Ort
can_ok($p, 'ort');
is( $p->ort, 'Templin, Stadtseerunde', sprintf("ort: %s", $p->ort) );

#
can_ok($p, qw(datum uhrzeit runden));
is( $p->datum, '13.12.2020', sprintf("datum: %s", $p->datum) );
is( $p->uhrzeit, '14:05', sprintf("uhrzeit: %s", $p->uhrzeit) );
is( $p->runden, 15, sprintf("runden: %s", $p->runden) );

