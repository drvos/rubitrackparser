use strict;
use warnings;
 
use 5.008;
 
use ExtUtils::MakeMaker;
WriteMakefile
(
    NAME          => 'rubiTrack2Web',
    AUTHOR        => 'Volker Schering <mail@volker-schering.de>',
    VERSION_FROM  => 'lib/rT2Web.pm',
    ABSTRACT_FROM => 'lib/rT2Web.pm',
    LICENSE       => 'perl',
    PREREQ_PM     => {
          'File::Basename' => '0',
          'Moose'          => '0.24',
    },
    TEST_REQUIRES => {
          'Test::More' => '0.47'
    },
    BUILD_REQUIRES => {
          'Other::Module' => '0'
    },
    EXE_FILES => [
           'script/rubitrackparser.pl'
    ],
    META_MERGE    => {
        'meta-spec' => { version => 1 },
         resources => {
             #repository => {
             #    type => 'git',
             #    url  => 'https://github.com/szabgab/perlmaven.com.git',
             #    web  => 'https://github.com/szabgab/perlmaveb.com',
             #},
             #bugtracker => {web => 'https://github.com/szabgab/perlmaven.com/issues'},
             homepage   => 'https://volker-schering.de',
         },
    },
 
);
