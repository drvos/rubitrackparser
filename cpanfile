on 'runtime' => sub {
    requires 'Moose','0.24';
    requires 'File::Basename','0';
    requires 'HTML::TagParser','0.20';
    requires 'Time::Piece', '0';
    requires 'namespace::autoclean','0.29';
};

on 'test' => sub {
    requires 'File::Basename','0';
    requires 'Test::Compile',v2.4.1;
    requires 'Test::More','0.47';
    requires 'Test::Pod','1.52';
    requires 'Text::Diff','1.45';
};
