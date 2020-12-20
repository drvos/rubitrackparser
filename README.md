# NAME

rtParser - Parser von exportierten Informationen aus der Software [rubiTrack Pro](https://www.rubitrack.com)

# SYNOPSIS

...

# DESCRIPTION

Exporte aus rubiTrack Pro, die mit der "Veröffentlichen" Funktion erstellt werden 
als Eintrag im Blog veröffentlichen.
Der rtParser durchsucht ein html-Export von Rubitrack und erstellt aus
bestimmten Informationen des Exports eine formatierte Ausgabe:
\* HTML-Tabelle

# ATTRIBUTES

...

# METHODS

## \_parseData

Ermittelt die Daten aus der übergebenen Datei:
\* Ort, Datum und Uhrzeit
\* Distanz und Dauer der Aktivität
\* Verschiedene Durchschnittswerte
\* Anstieg
\* Wetter und Temperatur

Die Art der Aktivität wird über die Durchschnittsgeschwindigkeit gewählt: 
Eine Durchschnittsgeschwindigkeit von kleiner 18 km/h ergibt 'Laufen',
alles darüber 'Radfahren'. 

# DEPENDENCIES

[rtParser](https://metacpan.org/pod/rtParser) requires [Moose](https://metacpan.org/pod/Moose), [HTML::TagParser](https://metacpan.org/pod/HTML%3A%3ATagParser).

# AUTHOR

Volker Schering <mail@volker-schering.de>
