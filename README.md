# NAME

rtParser - Parser von exportierten Informationen aus der Software [rubiTrack Pro](https://www.rubitrack.com)

# SYNOPSIS

...

# DESCRIPTION

Exporte aus rubiTrack Pro, die mit der "Veröffentlichen" Funktion erstellt werden 
als Eintrag im Blog veröffentlichen.
Der rtParser durchsucht ein html-Export von Rubitrack und erstellt aus
bestimmten Informationen des Exports eine formatierte Ausgabe:

1. HTML-Tabelle

Ermittelt folgende Daten aus der übergebenen Datei:

- Ort, Datum und Uhrzeit
- Art der Aktivität
- Distanz und Dauer der Aktivität
- Verschiedene Durchschnittswerte
- Anstieg
- Wetter und Temperatur

Die Art der Aktivität wird über die Durchschnittsgeschwindigkeit ermittelt. 
Eine Durchschnittsgeschwindigkeit kleiner 18 km/h ergibt 'Laufen',
alles darüber 'Radfahren'. 

# ATTRIBUTES

## Zusammenfassung der Aktivität

- location    Ort
- date        Datum
- time        Uhrzeit
- laps        Runden
- activity    Art der Aktivität

## Zusammenfassung und Runden

- avgspeed    Durchschnitliche Geschwindigkeit oder Pace
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

## as\_html

# DEPENDENCIES

[rtParser](https://metacpan.org/pod/rtParser) requires [Moose](https://metacpan.org/pod/Moose), [HTML::TagParser](https://metacpan.org/pod/HTML%3A%3ATagParser).

# AUTHOR

Volker Schering <mail@volker-schering.de>
