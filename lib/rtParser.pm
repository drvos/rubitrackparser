package rtParser;
use Moose;
use Moose::Util::TypeConstraints;

use HTML::TagParser;
use Data::Dumper;

use namespace::autoclean;

use v5.018;

our $VERSION = '0.1';
my @data;

=pod

=encoding utf8

=head1 NAME

rtParser - Parser von exportierten Informationen aus der Software L<rubiTrack Pro|https://www.rubitrack.com>

=head1 SYNOPSIS

...

=head1 DESCRIPTION

Exporte aus rubiTrack Pro, die mit der "Veröffentlichen" Funktion erstellt werden 
als Eintrag im Blog veröffentlichen.
Der rtParser durchsucht ein html-Export von Rubitrack und erstellt aus
bestimmten Informationen des Exports eine formatierte Ausgabe:

* HTML-Tabelle

Ermittelt folgende Daten aus der übergebenen Datei:
* Ort, Datum und Uhrzeit
* Art der Aktivität
* Distanz und Dauer der Aktivität
* Verschiedene Durchschnittswerte
* Anstieg
* Wetter und Temperatur

Die Art der Aktivität wird über die Durchschnittsgeschwindigkeit ermittelt. 
Eine Durchschnittsgeschwindigkeit kleiner 18 km/h ergibt 'Laufen',
alles darüber 'Radfahren'. 

=head1 ATTRIBUTES

* Zusammenfassung
** location     - Ort
** date         - Datum
** time         - Uhrzeit
** laps         - Runden
** activity     - Art der Aktivität
* Zusammenfassung und Runden
** avgspeed     - Durchschnitliche Geschwindigkeit oder Pace
** maxspeed     - Maximale Geschwindigkeit oder Pace
** distance	    - Distanz
** duration	    - Dauer
** heartrate	- Herzfrequenz
** cadence	    - Kadenz
** power	    - Leistung
** increase	    - Anstieg
** weather	    - Wetter
** temperature	- Temperatur

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
has 'avgspeed' => ( 
    is => 'rw', 
    isa => 'Str', 
    trigger => sub {
        my $self = shift;
        my $avgspeed = $data[0]{'Durchschn. Geschwindigkeit'};
        if (defined $avgspeed) {
            my $g = int(substr( $avgspeed, 0, index( $avgspeed, ',' ) ) );
            if ($g > 18) {
                $self->activity('Radfahren');
            } else {
                $self->activity('Laufen');
            }
        }
    } 
);
has 'maxspeed' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'distance' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'duration' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'heartrate' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'cadence' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'power' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'increase' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'weather' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'temperature' => ( is => 'rw', isa => 'Str', required => 0, default => '' );

=head1 METHODS

=head2 _parseData

=cut

sub _parseData 
{
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
    $self->_setAttributes(0);
}

=head2 _setAttributes

=cut

sub _setAttributes 
{
    my $self = shift;
    my $lap = shift; # Runde 0 = Zusammenfassung

    # Geschwindigkeit bzw. Pace
    if ($self->activity eq 'Laufen') {
        $self->maxspeed($data[$lap]{'Maximale Pace'});
        $self->avgspeed($data[$lap]{'Durchschn. Pace'});
    } else {
        $self->maxspeed($data[$lap]{'Maximale Geschwindigkeit'});
        $self->avgspeed($data[$lap]{'Durchschn. Geschwindigkeit'});
    }
    # Aktive Distanz und Dauer
    $self->distance($data[$lap]{'Aktive Distanz'});
    $self->duration($data[$lap]{'Aktive Dauer'});
    # Herzfrequenz
    $self->heartrate($data[$lap]{'Durchschn. Herzfrequenz'});
    $self->cadence($data[$lap]{'Durchschn. Kadenz'});
    # Anstieg
    $self->increase($data[$lap]{'Anstieg'});
    # Kadenz und Leistung
    $self->cadence($data[$lap]{'Durchschn. Kadenz'});
    $self->power($data[$lap]{'Durchschn. Leistung'});
    # Wetter und Temperatur
    $self->weather($data[$lap]{'Wetter'});
    $self->temperature($data[$lap]{'Temperatur'});
}

=head2 as_html

=cut

sub as_html
{
    my $self = shift;

}

=head1 DEPENDENCIES

L<rtParser> requires L<Moose>, L<HTML::TagParser>.

=head1 AUTHOR

Volker Schering E<lt>mailE<64>volker-schering.deE<gt>

=cut

no Moose;
__PACKAGE__->meta->make_immutable;
1;
