package rtParser;
use Moose;
use Moose::Util::TypeConstraints;

use HTML::TagParser;
use Data::Dumper;

use namespace::autoclean;

use v5.024;

our $VERSION = '0.1';
my @data;
my @values = qw("Aktive Distanz" "Aktive Dauer" "Durschn. Herzfrequenz" "Durschn. Kadenz" "Durschn. Geschwindigkeit" "Anstieg" "Maximale Geschwindigkeit" "Wetter" "Temperatur");

=pod

=encoding utf8

=head1 NAME

rtParser - Parser von exportierten Informationen aus der Software rubiTrack Pro

=head1 SYNOPSIS

...

=head1 DESCRIPTION

Exporte aus rubiTrack Pro, die mit der "Veröffentlichen" Funktion erstellt werden 
als Eintrag im Blog veröffentlichen.
Der rtParser durchsucht ein html-Export von Rubitrack und erstellt aus
bestimmten Informationen und zwei Bildern (activity und chart) des Exports einen
Wordpress-Beitrag auf VOSLOG

=head1 ATTRIBUTES

...

=cut

subtype 'RubiTrackExportFile'
  => as 'Str'
  => where { -e $_ }
  => message { "Datei ($_) existiert nicht." };

has 'rtexportfile' => (
    is  => 'ro',
    isa =>  'RubiTrackExportFile',
    required => 1,
    trigger => sub { 
        &_parseData;
        return
    }
);
has 'location' => ( is  => 'rw', isa => 'Str', required => 0, default => '' );
has 'date' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'time' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'laps' => ( is => 'rw', isa => 'Int', required => 0, default => 0 );
has 'activity' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'averagespeed' => ( 
    is => 'rw', 
    isa => 'Str', 
    trigger => sub {
        my $self = shift;
        my $averagespeed = $data[0]{'Durchschn. Geschwindigkeit'};
        if (defined $averagespeed) {
            my $g = int(substr( $averagespeed, 0, index( $averagespeed, ',' ) ) );
            if ($g > 18) {
                $self->activity('Radfahren');
            } else {
                $self->activity('Laufen');
            }
        }
    } 
);

=head1 METHODS

=head2 _parseData

Ermittelt den Ort aus dem Titel-Tag (<title>) der übergebenen Datei.

=cut

sub _parseData {
    my $self =shift;
    my $i = 0;
    my $html = HTML::TagParser->new( $self->rtexportfile );
    foreach my $d ( $html->getElementsByClassName( "propertylist" ) ) {
        my %kv;
        foreach my $e ( $d->subTree->getElementsByClassName( "property" ) ) {
            #my $k = ($e->firstChild)->innerText;
		    #my $v = ($e->lastChild)->innerText;
            #printf("%d. %s ==> %s\n", $i, $k, $v);
            $kv{($e->firstChild)->innerText} = ($e->lastChild)->innerText;
        }
        push @data, \%kv;
        $i++;
    }

    print Dumper(@data);
    
    # Ort
    my $elem = $html->getElementsByTagName( "title" );
    $self->location( $elem->innerText() ) if ref $elem;
    # Datum
    $self->date($data[0]{'Datum'});
    # Uhrzeit
    $self->time($data[0]{'Uhrzeit'});
    # Runden
    $self->laps(--$i);
    # Durschnittliche Geschwindigkeit
    $self->averagespeed($data[0]{'Durchschn. Geschwindigkeit'});
}

=head1 DEPENDENCIES

L<rtParser> requires L<Moose>, L<HTML::TagParser>.

=head1 AUTHOR

Volker Schering E<lt>mailE<64>volker-schering.deE<gt>

=cut

no Moose;
__PACKAGE__->meta->make_immutable;
1;
