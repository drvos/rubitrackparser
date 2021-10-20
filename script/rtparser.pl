#!/usr/bin/env perl
#
##
use utf8;
use strict;
use warnings;
use v5.018;

use lib './lib';

use rtParser;

my ($file) = @ARGV;

die "Need rubiTrack Exportfile\n" unless defined $file;

my $p = rtParser->new( 'rtexportfile' => $file );
say $p->as_html();

exit 0;
