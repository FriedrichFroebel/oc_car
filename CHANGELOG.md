# Entwicklungsversion

* Teilweise bessere Benennung der verwendeten Variablen sowie zusätzliches Maskieren/Escapen von Variablen.
* Keine temporäre Speicherung der JSON-Dateien für Start- und Zielpunkt mehr notwendig.

# Version 0.5 - 2020-04-26

* Übersichtlichere Formatierung des Skripts.
* Umstellung auf HTTPS, insofern die Dienste dies unterstützen.
* Kompatibilität für Windows (hinsichtlich Kodierungsproblemen) hergestellt - das Skript funktioniert mit den entsprechenden Pfaden in der `PATH`-Variable nun auch ohne weitere Anpassung direkt unter Windows (mittels Git Bash).

# Version 0.4 - 2015-07-12

* Abruf der Koordinaten nun über nominatim.openstreetmap.org.
* Leerzeichen in Ortsnamen werden durch Plus ersetzt.
* [`JSON.sh`](https://github.com/dominictarr/JSON.sh/blob/master/JSON.sh) für ordentliche Funktionsweise notwendig.

# Version 0.3.4 - 2015-06-26

* Wählbare Cachetypen.
* Beschränkungsmöglichkeit für die Schwierigkeits- und Geländewertung.
* Bestehende Config-Dateien funktionieren nicht mehr.
* Suche wird begrenzt auf aktuell verfügbare Caches.

# Version 0.3.3 - 2015-06-07

* Radius nun auch als Gleitkommazahl möglich.
* Übernahme der (Weiter-)Entwicklung durch FriedrichFröbel.

# Version 0.3.2  - 2014-10-26

* Neuer Service zur Routenerstellung wegen Problemen mit vorherigem Anbieter.

# Version 0.3.1 - 2014-03-30

* E-Mail-Text im Menü änderbar.
* Wegfall der Größenbeschränkung - je 500 Listings wird eine E-Mail geschickt.

# Version 0.3 - 2014-03-29

* Das Script kann jetzt selbst Routen erzeugen. Es muss keine GPX-Datei mehr übergeben werden.
* Änderung in der Parameterverwaltung
  * Als einziger Aufrufparameter bleibt der Dateiname einer Route (GPX), dieses ist aber optional.
  * Radius, User und E-Mail-Daten werden in einer externen `.conf`-Datei verwaltet. Diese wird selbst erzeugt, wenn sie nicht vorhanden ist.
  * In der Eingabemaske kann jetzt ein Start und ein Ziel der Route angegeben werden. Diese Route wird abgerufen, wenn keine Route beim Scriptstart übergeben wurde.
  * Bei Änderung von Parametern werden diese in der `.conf`-Datei gespeichert.
* Bekannter Fehler: Bei Anzahl Listings > 500 klappt das (noch) nicht :-(

# Version 0.2 - 2014-03-27

* Abfrage, ob User gefunden werden konnte, eingebunden.
* Abfrage, ob gültige GPX-Datei vorliegt.
* Abfrage, ob Radius zwischen 0.1 und 10 liegt.

# Version 0.1 - 2014-03-26

* Erste (nicht öffentlich verfügbare) Version von ka_be.
