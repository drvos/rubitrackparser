use strict;
use warnings;
use v5.018;

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

can_ok($p, qw(date time laps activity));
is( $p->date, '13.12.2020', sprintf("date: %s", $p->date) );
is( $p->time, '14:05', sprintf("time: %s", $p->time) );
is( $p->laps, 15, sprintf("laps: %s", $p->laps) );
is( $p->activity, 'Laufen', sprintf("activity: %s", $p->activity) );

can_ok($p, qw(avgspeed maxspeed));
is( $p->avgspeed, '9,1 km/h', sprintf("avgspeed: %s", $p->avgspeed) );
is( $p->maxspeed, '10,4 km/h', sprintf("maxspeed: %s", $p->maxspeed) );

can_ok($p, qw(distance duration));
is( $p->distance, '14,08 km', sprintf("distance: %s", $p->distance) );
is( $p->duration, '1:32:35 hrs', sprintf("duration: %s", $p->duration) );

can_ok($p, qw(heartrate));
is( $p->heartrate, '142 bpm', sprintf("heartrate: %s", $p->heartrate) );

can_ok($p, qw(cadence power));
is( $p->cadence, '82 rpm', sprintf("cadence: %s", $p->cadence) );
is( $p->power, '273 Watt', sprintf("power: %s", $p->power) );

can_ok($p, qw(weather temperature));
is( $p->weather, 'Bewölkt', sprintf("weather: %s", $p->weather) );
is( $p->temperature, '1,0 ℃', sprintf("temperature: %s", $p->temperature) );

