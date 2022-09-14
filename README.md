# NAME

rtParser - Parser von exportierten Informationen aus der 
Software [rubiTrack Pro](https://www.rubitrack.com)

# SYNOPSIS

    use rtParser;
    my $p = rtParser->new( 'rtexportfile' => '/rubi/track/export.html' );
    say $p->as_html();

# DESCRIPTION

Der rtParser durchsucht ein html-Export von Rubitrack und erstellt aus
bestimmten Informationen des Exports eine formatierte Ausgabe:

1. HTML-Tabelle
2. Markdown-Tabelle

Der genannte html-Export wird in Rubitrack mit der
Veröffentlichen-Funktion erstellt.

Folgende Daten werden aus der übergebenen Datei ermittelt:

- Ort, Datum und Uhrzeit
- Art der Aktivität
- Distanz und Dauer der Aktivität
- Verschiedene Durchschnittswerte
- Anstieg
- Wetter und Temperatur

Die Art der Aktivität wird über die Durchschnittsgeschwindigkeit ermittelt.

- bis 6 km/h ergibt 'Wandern'
- größer 6 km/h ergibt 'Laufen'
- größer 18 km/h ergibt 'Radfahren'

# ATTRIBUTES

## Zusammenfassung der Aktivität

- location    Ort
- date        Datum
- time        Uhrzeit
- laps        Runden
- activity    Art der Aktivität

## Zusammenfassung und Runden

- avgspeed    Durchschnittliche Geschwindigkeit oder Pace
- maxspeed    Maximale Geschwindigkeit oder Pace
- distance    Distanz
- duration    Dauer
- heartrate   Herzfrequenz
- cadence     Kadenz
- power       Leistung
- increase    Anstieg
- weather     Wetter
- temperature Temperatur

# METHODS

### `title`

Gibt einen Titel der aktuellen Aktivität aus.

_Laufen in Templin am 13.12.2020_

## Ausgabefunktionen

Die folgenden Funktionen geben die geparsten Informationen (eine Auswahl) in einer
formatierten Tabelle aus.
Folgende Attribute sind enthalten:

- Distanz
- Dauer
- Herzfrequenz
- Kadenz
- Durchschnittliche Geschwindigkeit/Pace
- Maximale Geschwindigkeit/Pace
- Anstieg
- Wetter und Temperatur

### `as_html`

#### Ausgabe

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

### `as_markdown`

#### Ausgabe

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

# DEPENDENCIES

[rtParser](https://metacpan.org/pod/rtParser) requires [Moose](https://metacpan.org/pod/Moose) and [HTML::TagParser](https://metacpan.org/pod/HTML%3A%3ATagParser).

## Installation Dependencies

    cpm install -g

or

    cpanm --installdeps .

# AUTHOR

Volker Schering <mail@volker-schering.de>

# COPYRIGHT AND LICENSE

Copyright 2020 by Volker Schering

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 
