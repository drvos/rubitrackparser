NAME
    rtParser - Parser von exportierten Informationen aus der Software
    rubiTrack Pro

SYNOPSIS
    ...

DESCRIPTION
    Exporte aus rubiTrack Pro, die mit der "Veröffentlichen" Funktion
    erstellt werden als Eintrag im Blog veröffentlichen. Der rtParser
    durchsucht ein html-Export von Rubitrack und erstellt aus bestimmten
    Informationen und zwei Bildern (activity und chart) des Exports einen
    Wordpress-Beitrag auf VOSLOG

ATTRIBUTES
    ...

METHODS
  _parseData
    Ermittelt die Daten aus der übergebenen Datei: * Ort, Datum und Uhrzeit
    * Distanz und Dauer der Aktivität * Verschiedene Durchschnittswerte *
    Wetter und Temperatur

    Die Art der Aktivität wird über die Durchschnittsgeschwindigkeit
    gewählt: Laufen oder Radfahren

DEPENDENCIES
    rtParser requires Moose, HTML::TagParser.

AUTHOR
    Volker Schering <mail@volker-schering.de>

