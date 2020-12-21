use strict;
use warnings;
use v5.018;

use Test::More tests => 6;
use Text::Diff;

use lib '../lib';

my $exportfile = 't/export/20201213-140543.html';
my $md = '';

###
use rtParser;

use_ok('rtParser');

my $p = rtParser->new( 'rtexportfile' => $exportfile );
isa_ok( $p, 'rtParser' );

can_ok($p, qw(as_md));
my $output = $p->as_md;
is($output, $md, 'Markdown-Table') or diag explain diff(\$output, \$md);

