Change log:
-----------
*2.09
- Updatefunktion korigiert
- Kleine GUI anpassungen
*2.08
- Previewfunktion funktioniert nun auch beim ersten Klick
- Updatefunktion eingebaut
*2.07
- Sicherheitsabfragen hinzugef�gt
- Oberfl�che optimiert
- Format kann nun frei gew�hlt werden
*2.06
- Verkn�pfte Dateien werden nun automatisch mit Character Editor ge�ffnet.
- Es werden Tooltips bei der Vorschau angezeigt
*2.05
- Fehler bei Schlie�en mit Infobereich korrigiert
- Vorschaubild ist nun transparent
- Vorschaufenster �ffnet sich nun nicht mehr verz�gert
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
- Oberfl�chlich optimiert

Hinzuf�gen eigener Grafiken:
----------------------------
Eigene Grafiken k�nnen einfach hinzugef�gt werden,
indem die Vorlagen f�r Character im Image Ordner/Aktuelles Format hinzugef�gt werden.
Alle Grafiken m�ssen sich im PNG-Format (Portable Network Graphics - 32Bitt mit Alpha Unterst�tzung) befinden.
Die Grafiken werden dann automatisch hinzugef�gt.

Beispiel:
Die Grafiken sollten der aktuellen Kategorie entsprechen im korekten Ordner kopiert werden.
Eine R�stung-Grafik im Format 128 * 192 sollte also im Ordner ./Images/128-192/R�stung/ hinzugef�gt werden.

Speicherformat: (CHS-Datei)
---------------
Folgender Art ist eine CHS Speicherdateien, die CharacterEditor anlegt, aufgebaut.
Somit ist es Ihnen m�glich diese selbst auszulesen.

Dateiformat CHS-Dateien:

String            (Teststring "CE_3 oder CE_4")
Byte              (TileSet Format: RPGM2k u RPGM2k3 = 0,1, RPGMXP = 2) Erst ab CE_4 vorhanden!
Byte              (Menge der Ebenen)

Byte              (L�nge der Namen der Ebene)
String            (Ebenenname)
Long              (Gr��e der PNG-Datei in Byte)
Data              (PNG-Datei)
Long              (OffsetX)
Long              (OffsetY)

Long              (Hintergrundfarbe)
Float             (Zoom wert)
Byte              (Aktuell ausgew�hlte Ebene)

Grafiken oder andere Inhalte ver�ffentlichen:
----------------------------------------------
Solltet ihr neue Character, Vorlagen usw. erstellen,
k�nnt ihr mir diese gern zuschicken.
Ich w�rde diese dann im Installationsarchiv hinzuf�gen, so h�tten auch andere was davon.

Vielen Dank im Voraus!

Kontakt:
http://purefreak.pu.funpic.de/
dergarty@freenet.de

Copyright Kai Gartenschl�ger, 2007
Letzte �nderungen: 13.M�rz 2008