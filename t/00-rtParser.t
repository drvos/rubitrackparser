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
can_ok($p, 'location');
is( $p->location, 'Templin, Stadtseerunde', sprintf("location: %s", $p->location) );

#
can_ok($p, qw(date time laps));
is( $p->date, '13.12.2020', sprintf("date: %s", $p->date) );
is( $p->time, '14:05', sprintf("time: %s", $p->time) );
is( $p->laps, 15, sprintf("laps: %s", $p->laps) );

#
can_ok($p, qw(activity averagespeed));
is( $p->activity, 'Laufen', sprintf("activity: %s", $p->activity) );
is( $p->averagespeed, '9,1 km/h', sprintf("averagespeed: %s", $p->averagespeed) );
