use strict;
use warnings;
use v5.018;

use Test::More tests => 4;
use Text::Diff;
use File::Basename;

use lib '../lib';

my $exportfile = 't/export/20201213-140543.html';
my($filename, $dirs, $suffix) = fileparse($exportfile, qr/\.[^.]*/);
my $activitypicture = sprintf("%s%s_activity.png", $dirs, $filename);
###
use rtParser;

use_ok('rtParser');

my $p = rtParser->new( 'rtexportfile' => $exportfile );
isa_ok( $p, 'rtParser' );

can_ok($p, qw(rtactivitypicture));
is($p->rtactivitypicture(), $activitypicture, sprintf("Activitypicture: %s", $activitypicture));
