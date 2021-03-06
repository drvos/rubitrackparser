use strict;
use warnings;
 
use 5.018;

use ExtUtils::MakeMaker;
WriteMakefile
(
    NAME          => 'rtParser',
    AUTHOR        => 'Volker Schering <mail@volker-schering>',
    VERSION_FROM  => 'lib/rtParser.pm',
    ABSTRACT_FROM => 'lib/rtParser.pm',
    LICENSE       => 'perl',
    PREREQ_PM     => {
          'File::Basename'  => '0',
          'Moose'           => '0.24',
          'HTML::TagParser' => '0.20',
          'File::Basename'  => '0',
    },
    TEST_REQUIRES => {
          'Test::More'      => '0.47',
          'Test::Pod'       => '1.52',
          'Test::Compile'   => '2.4.1',
          'Text::Diff'		=> '1.45',
          'File::Basename'  => '0',
    },
    BUILD_REQUIRES => {
    },
    EXE_FILES => [
        'script/rtparser.pl'
    ],
    META_MERGE    => {
        'meta-spec' => { version => 1 },
         resources => {
             repository => {
                 type => 'git',
                 url  => 'https://github.com/drvos/rubitrackparser.git',
                 web  => 'https://github.com/drvos/rubitrackparser',
             },
             bugtracker => {web => 'https://github.com/drvos/rubitrackparser/issues'},
             homepage   => 'https://volker-schering.de',
         },
    },
    dist => {
      PREOP => 'perldoc -u lib/rtParser.pm | pod2markdown > README.md',
    },
);
