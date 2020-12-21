package rtParser;
use Moose;
use Moose::Util::TypeConstraints;

use HTML::TagParser;
use Data::Dumper;

use namespace::autoclean;

use v5.018;

our $VERSION = '1.0';
my @data;

###############################################################################
# attributes
###############################################################################
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
has 'avgpace' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'maxpace' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'distance' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'duration' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'heartrate' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'cadence' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'power' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'increase' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'weather' => ( is => 'rw', isa => 'Str', required => 0, default => '' );
has 'temperature' => ( is => 'rw', isa => 'Str', required => 0, default => '' );

################################################################################
# _parseData
################################################################################
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

################################################################################
# _setAttributes
################################################################################
sub _setAttributes 
{
    my $self = shift;
    my $lap = shift; # Runde 0 = Zusammenfassung

    # Geschwindigkeit und Pace
    $self->maxpace($data[$lap]{'Maximaler Pace'});
    $self->avgpace($data[$lap]{'Durchschn. Pace'});
    $self->maxspeed($data[$lap]{'Maximale Geschwindigkeit'});
    $self->avgspeed($data[$lap]{'Durchschn. Geschwindigkeit'});
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

#
# Outputfunctions
#

################################################################################
# as_html
################################################################################
sub as_html
{
    my $self = shift;

	my $html ="
<table>
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
    <td>%s:</td>
    <td>%s</td>
    <td>Maximal:</td>
    <td>%s</td>
  </tr>
  <tr align='right'>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Anstieg:</td>
    <td>%s</td>
  </tr>
  <tr>
    <td colspan='4' align='right'>%s bei %s</td>
  </tr>
</table>
";
  return sprintf($html,
	$self->distance,
	$self->duration,
	$self->heartrate,
	$self->cadence,
    ($self->activity eq 'Laufen') ? 'Pace' : 'Geschwindigkeit',
    ($self->activity eq 'Laufen') ? $self->avgpace : $self->avgspeed,
    ($self->activity eq 'Laufen') ? $self->maxpace : $self->maxspeed,
	$self->increase,
	$self->weather,
	$self->temperature
  );
}

################################################################################
# as_markdown
################################################################################
sub as_markdown
{
    my $self = shift;

    my $md = "
|Attribut|Wert|
|:---|---:|
|Distanz|%s|
|Dauer|%s|
|Herzfrequenz|%s|
|Kadenz|%s|
|%s|%s|
|Maximal|%s|
|Anstieg|%s|
|Wetter|%s|
|Temperatur|%s|
";
  return sprintf($md,
	$self->distance,
	$self->duration,
	$self->heartrate,
	$self->cadence,
    ($self->activity eq 'Laufen') ? 'Pace' : 'Geschwindigkeit',
    ($self->activity eq 'Laufen') ? $self->avgpace : $self->avgspeed,
    ($self->activity eq 'Laufen') ? $self->maxpace : $self->maxspeed,
	$self->increase,
	$self->weather,
	$self->temperature
  );
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=encoding utf8

=head1 NAME

rtParser - Parser von exportierten Informationen aus der 
Software L<rubiTrack Pro|https://www.rubitrack.com>

=head1 SYNOPSIS

  
  use rtParser;
  my $p = rtParser->new( 'rtexportfile' => '/rubi/track/export.html' );
  say $p->as_html();

=head1 DESCRIPTION

Der rtParser durchsucht ein html-Export von Rubitrack und erstellt aus
bestimmten Informationen des Exports eine formatierte Ausgabe:

=over

=item 1 HTML-Tabelle

=item 2 Markdown-Tabelle

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

=head1 METHODS

Die folgenden Funktionen geben die geparsten Informationen (eine Auswahl) in einer
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

=head2 C<as_html>

=head3 Ausgabe

  <table border='1'>
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
      <td>Pace:</td>
      <td>6:34 min/km</td>
      <td>Maximal:</td>
      <td>5:45 min/km</td>
    </tr>
    <tr align='right'>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>Anstieg:</td>
      <td>45 m</td>
    </tr>
    <tr>
      <td colspan='4' align='right'>Bewölkt bei 1,0 ℃</td>
    </tr>
  </table>

=head2 C<as_markdown>

=head3 Ausgabe

  |Attribut    |Wert             |
  |:---        |---:             |
  |Distanz     |14,08 km         |
  |Dauer       |1:32:35 hrs      |
  |Herzfrequenz|142 bpm          |
  |Kadenz      |82 rpm           |
  |Pace        |6:34 min/km      |
  |Maximal     |5:45 min/km      |
  |Anstieg     |45 m             |
  |Wetter      |Bewölkt bei 1,0 ℃|

=head1 DEPENDENCIES

L<rtParser> requires L<Moose> and L<HTML::TagParser>.

=head1 AUTHOR

Volker Schering E<lt>mailE<64>volker-schering.deE<gt>

=head1 COPYRIGHT AND LICENSE
 
Copyright 2020 by Volker Schering
 
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 
 
