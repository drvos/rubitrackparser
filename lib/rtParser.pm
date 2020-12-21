package rtParser;
use Moose;
use Moose::Util::TypeConstraints;

use HTML::TagParser;
use Data::Dumper;

use namespace::autoclean;

use v5.018;

our $VERSION = '0.8';
my @data;

=pod

=encoding utf8

=head1 NAME

rtParser - Parser von exportierten Informationen aus der 
Software L<rubiTrack Pro|https://www.rubitrack.com>

=head1 SYNOPSIS

...

=head1 DESCRIPTION

Der rtParser durchsucht ein html-Export von Rubitrack und erstellt aus
bestimmten Informationen des Exports eine formatierte Ausgabe:

=over

=item 1

HTML-Tabelle

=back

Der genannte html-Export wird in Rubitrack mit der
Veröffentlichen-Funktion erstellt.

Folgende Daten werden aus der übergebenen Datei ermittelt:

=over

=item Ort, Datum und Uhrzeit

=item Art der Aktivität

=item Distanz und Dauer der Aktivität

=item Verschiedene Durchschnittswerte

=item Anstieg

=item Wetter und Temperatur

=back

Die Art der Aktivität wird über die Durchschnittsgeschwindigkeit ermittelt. 
Eine Durchschnittsgeschwindigkeit kleiner 18 km/h ergibt 'Laufen',
alles darüber 'Radfahren'. 

=head1 ATTRIBUTES

=head2 Zusammenfassung der Aktivität

=over

=item S<location    Ort>

=item S<date        Datum>

=item S<time        Uhrzeit>

=item S<laps        Runden>

=item S<activity    Art der Aktivität>

=back

=head2 Zusammenfassung und Runden

=over

=item S<avgspeed    Durchschnittliche Geschwindigkeit oder Pace>

=item S<maxspeed    Maximale Geschwindigkeit oder Pace>

=item S<distance    Distanz>

=item S<duration    Dauer>

=item S<heartrate   Herzfrequenz>

=item S<cadence     Kadenz>

=item S<power       Leistung>

=item S<increase    Anstieg>

=item S<weather     Wetter>

=item S<temperature Temperatur>

=back

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

    #print Dumper(@data);
    
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

Die Funktion I<as_html> gibt die geparsten Informationen (eine Auswahl) in einer
formatierten Tabelle aus.
Folgende Attribute sind enthalten:

=over

=item * Distanz

=item * Dauer

=item * Herzfrequenz

=item * Kadenz

=item * Durchschnittliche Geschwindigkeit/Pace

=item * Maximale Geschwindigkeit/Pace

=item * Anstieg

=item * Wetter und Temperatur

=back

...

=begin html

  <tr align='right'>
    <td>Distanz:</td>
    <td>14,08 km</td>
    <td>Dauer:</td>
    <td>1:32:35 hrs</td>
  </tr>
  <tr align='right'>
    <td>Herzfrequenz:</td>
    <td>142 bpm</td>
    <td>Kadenz:</td>
    <td>82 rpm</td>
  </tr>
  <tr align='right'>
    <td>Geschwindigkeit:</td>
    <td>9,1 km/h</td>
    <td>Anstieg:</td>
    <td>45 m</td>
  </tr>
  <tr align='right'>
    <td>Max. Geschwindigkeit:</td>
    <td>10,4 km/h</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan='4' align='right'>Bewölkt bei 1,0 ℃</td>
  </tr>

=end html

=cut

sub as_html
{
    my $self = shift;

	my $html ="
  <tr align='right'>
    <td>Distanz:</td>
    <td>%s</td>
    <td>Dauer:</td>
    <td>%s</td>
  </tr>
  <tr align='right'>
    <td>Herzfrequenz:</td>
    <td>%s</td>
    <td>Kadenz:</td>
    <td>%s</td>
  </tr>
  <tr align='right'>
    <td>Geschwindigkeit:</td>
    <td>%s</td>
    <td>Anstieg:</td>
    <td>%s</td>
  </tr>
  <tr align='right'>
    <td>Max. Geschwindigkeit:</td>
    <td>%s</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan='4' align='right'>%s bei %s</td>
  </tr>";
  return sprintf($html,
	$self->distance,
	$self->duration,
	$self->heartrate,
	$self->cadence,
	$self->avgspeed,
	$self->increase,
	$self->maxspeed,
	$self->weather,
	$self->temperature
  );
}

=head1 DEPENDENCIES

L<rtParser> requires L<Moose>, L<HTML::TagParser>.

=head1 AUTHOR

Volker Schering E<lt>mailE<64>volker-schering.deE<gt>

=cut

no Moose;
__PACKAGE__->meta->make_immutable;
1;
