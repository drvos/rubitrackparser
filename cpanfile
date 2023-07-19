on 'runtime' => sub {
    requires 'Moose','0.24';
    requires 'DateTime','1.59';
    requires 'File::Basename','0';
    requires 'HTML::TagParser','0.20';
    requires 'Email::Stuffer','0.020';
    requires 'MIME::Base64', '3.16';
    requires 'Authen::SASL','2.16';
    requires 'namespace::autoclean','0.29';
    requires 'DateTime::Format::Strptime','1.79';
};

feature 'ssl', 'SSL support' => sub {
    requires 'IO::Socket::SSL';
};

on 'test' => sub {
    requires 'File::Basename','0';
    requires 'Test::Compile',v2.4.1;
    requires 'Test::More','0.47';
    requires 'Test::Pod','1.52';
    requires 'Text::Diff','1.45';
};
