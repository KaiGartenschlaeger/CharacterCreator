Change log:
-----------
*2.09
- Updatefunktion korigiert
- Kleine GUI anpassungen
*2.08
- Previewfunktion funktioniert nun auch beim ersten Klick
- Updatefunktion eingebaut
*2.07
- Sicherheitsabfragen hinzugefügt
- Oberfläche optimiert
- Format kann nun frei gewählt werden
*2.06
- Verknüpfte Dateien werden nun automatisch mit Character Editor geöffnet.
- Es werden Tooltips bei der Vorschau angezeigt
*2.05
- Fehler bei Schließen mit Infobereich korrigiert
- Vorschaubild ist nun transparent
- Vorschaufenster öffnet sich nun nicht mehr verzögert
- Speichern nur noch aufrufbar wenn Grafiken im Speicher liegen
*2.04
- Infobereich aktualisiert
- Fehler bei Vorschau gefixt
- Geschwindigkeitsoptimierung
- Bug fixes
*2.03:
- Eigenen Grafik zuweisen Dialog eingebaut
- Speicherformat optimiert
- Bug fixes
*2.00
- Arbeit nun mit Image anstatt einen Screen,
  was der CPU erheblich zugute kommt.
- Oberflächlich optimiert

Hinzufügen eigener Grafiken:
----------------------------
Eigene Grafiken können einfach hinzugefügt werden,
indem die Vorlagen für Character im Image Ordner/Aktuelles Format hinzugefügt werden.
Alle Grafiken müssen sich im PNG-Format (Portable Network Graphics - 32Bitt mit Alpha Unterstützung) befinden.
Die Grafiken werden dann automatisch hinzugefügt.

Beispiel:
Die Grafiken sollten der aktuellen Kategorie entsprechen im korekten Ordner kopiert werden.
Eine Rüstung-Grafik im Format 128 * 192 sollte also im Ordner ./Images/128-192/Rüstung/ hinzugefügt werden.

Speicherformat: (CHS-Datei)
---------------
Folgender Art ist eine CHS Speicherdateien, die CharacterEditor anlegt, aufgebaut.
Somit ist es Ihnen möglich diese selbst auszulesen.

Dateiformat CHS-Dateien:

String            (Teststring "CE_3 oder CE_4")
Byte              (TileSet Format: RPGM2k u RPGM2k3 = 0,1, RPGMXP = 2) Erst ab CE_4 vorhanden!
Byte              (Menge der Ebenen)

Byte              (Länge der Namen der Ebene)
String            (Ebenenname)
Long              (Größe der PNG-Datei in Byte)
Data              (PNG-Datei)
Long              (OffsetX)
Long              (OffsetY)

Long              (Hintergrundfarbe)
Float             (Zoom wert)
Byte              (Aktuell ausgewählte Ebene)

Grafiken oder andere Inhalte veröffentlichen:
----------------------------------------------
Solltet ihr neue Character, Vorlagen usw. erstellen,
könnt ihr mir diese gern zuschicken.
Ich würde diese dann im Installationsarchiv hinzufügen, so hätten auch andere was davon.

Vielen Dank im Voraus!

Kontakt:
http://purefreak.pu.funpic.de/
dergarty@freenet.de

Copyright Kai Gartenschläger, 2007
Letzte Änderungen: 13.März 2008