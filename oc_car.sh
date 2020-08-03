#!/bin/bash
#
# Version 0.5

# Aufruf des Scripts:
# z.B.: Script Inputfile Radius in km user
# ./oc_car.sh route.gpx 1.5 ka_be
# Alle Parameter MÜSSEN angegeben werden!!!
# Eine Route kann man sich ohne Anmeldung z.B. bei openrouteservice.org/?lang=de# erzeugen und als GPX-Datei speichern.

# Für dieses Script müssen gpsbabel und BC installiert sein.
# Wenn sendemail installiert ist, kann eine Mail mit angehängter GPX-Datei versendet werden.

# System ermitteln.
case "$(uname -s)" in
    CYGWIN*|MINGW*)    isWindows=true;;
    *)                 isWindows=false
esac

# Config-Datei prüfen.
if [ -f ./oc_car.conf ] ; then
    echo " "
else {
    # Schreibe Initialwerte in config-Datei
    echo "ocUser=\"User\""
    echo "Radius=2"
    echo "Start=\"Stuttgart\""
    if [ "$is_windows" = true ]; then
        echo "Ziel=\"Muenchen\""
    else
        echo "Ziel=\"München\""
    fi
    echo "Arten=\"alle\""
    echo "Difficulty=\"1-5\""
    echo "Terrain=\"1-5\""
    echo "sender=\"absender@gmail.com\""
    echo "receiver=\"absender@gmail.com\""
    echo "tls=\"tls=yes\""
    echo "smtp=\"smtp.gmail.com:587\""
    echo "mailuser=\"absender@gmail.com\""
    echo "mailpassword=\"password\""
    echo "subject=\"oc_car.sh - Die GPX-Datei für Deine Route\""
    echo "body=\"Die GPX-Datei für Deine Route!\""
} >> ./oc_car.conf
fi

# Externe Variablen einbinden.
source oc_car.conf

# Überprüfen der GPX-Datei, bzw. ob eine GPX-Datei im Aufruf enthalten war.
input=$1
if gpsbabel -i gpx -f $input -o gpx -F - > /dev/null; then
    #echo "GPX-Datei ist gültig"
    gpxok=true
else
    #echo "GPX-Datei ist ungültig! Es wird ein Route über Start/Ziel erstellt."
    gpxok=false
fi

# Menü
while [ 1 ]
do
    clear
    echo "Folgende Parameter wurden in der Konfigurationsdatei gefunden:"
    echo "[U]ser: ${ocUser}"
    echo "[R]adius: ${Radius}"
    echo "[S]tart: ${Start}"
    echo "[Z]iel: ${Ziel}"
    echo "[A]rten: ${Arten}"
    echo "[D]ifficulty: ${Difficulty}"
    echo "[T]errain: ${Terrain}"
    echo "[B]etreffzeile: ${subject}"
    echo "[M]ail-Text: ${body}"
    echo "Für den E-Mail-Versand werden die in oc_car.conf hinterlegten Parameter genutzt."
    echo ""
    if [ "${gpxok}" = true ]; then
        echo "Es wurde eine gültige GPX-Datei übergeben. Es wird keine neue Route berechnet."
    else
        echo "Es wurde keine gültige GPX-Datei übergeben. Es wird eine neue Route berechnet."
    fi
    echo ""
    echo "Sollen Parameter geändert werden? [N]ein, [E]nde -> [U,R,S,Z,A,D,T,B,M,N,E]"

    read answer
    case $answer in
        # Eingabe des Benutzernamens.
        u*|U*)  echo "Bitte neuen Benutzer eingeben:";
                read ocUser;
                grep -v ocUser oc_car.conf > tempdatei;
                mv tempdatei oc_car.conf;
                echo "ocUser=\"${ocUser}\"" >> oc_car.conf;;

        # Eingabe des Radius.
        r*|R*)  echo "Bitte neuen Radius eingeben:";
                read Radius;
                grep -v Radius oc_car.conf > tempdatei;
                mv tempdatei oc_car.conf;
                echo "Radius=${Radius}" >> oc_car.conf;;

        # Eingabe des Starts.
        s*|S*)  echo "Bitte neuen Start eingeben:";
                read Start;
                if [ "${isWindows}" = true ]; then
                    # Umlaute ersetzen.
                    Start="$( echo "${Start}" | sed -e 's/Ä/Ae/g' -e 's/Ö/Oe/g' -e 's/Ü/Ue/g' -e 's/ä/ae/g' -e 's/ö/oe/g' -e 's/ü/ue/g' -e 's/ß/ss/g' )"
                fi
                # Leerzeichen durch Plus ersetzen.
                Start="$( echo "${Start}" | sed -e 's/ /+/g' )"
                grep -v Start oc_car.conf > tempdatei;
                mv tempdatei oc_car.conf;
                echo "Start=\"${Start}\"" >> oc_car.conf;;

        # Eingabe des Ziels.
        z*|Z*)  echo "Bitte neues Ziel eingeben:";
                read Ziel;
                if [ "${isWindows}" = true ]; then
                    # Umlaute ersetzen.
                    Ziel="$( echo "${Ziel}" | sed -e 's/Ä/Ae/g' -e 's/Ö/Oe/g' -e 's/Ü/Ue/g' -e 's/ä/ae/g' -e 's/ö/oe/g' -e 's/ü/ue/g' -e 's/ß/ss/g' )"
                fi
                # Leerzeichen durch Plus ersetzen.
                Ziel="$( echo "${Ziel}" | sed -e 's/ /+/g' )"
                grep -v Ziel oc_car.conf > tempdatei;
                mv tempdatei oc_car.conf;
                echo "Ziel=\"${Ziel}\"" >> oc_car.conf;;

        # Eingabe der Cachetypen.
        a*|A*)  echo "Bitte die gewünschten Cachetypen durch Kommas getrennt eingeben (möglich: alle, Traditional, Multi, Quiz, Virtual, Event, Webcam, Moving, Math/Physics, Drive-In, Other):";
                read Arten;
                Arten=$( echo "${Arten}" | sed -e 's/,/|/g' -e 's/ //g' )
                grep -v Arten oc_car.conf > tempdatei;
                mv tempdatei oc_car.conf;
                echo "Arten=\"${Arten}\"" >> oc_car.conf;;

        # Eingabe der Schwierigkeitswertung.
        d*|D*)  echo "Bitte neuen Schwierigkeitsbereich (nur Ganzzahlen von 1 bis 5, z. B. 1-3) eingeben:";
                read Difficulty;
                Difficulty=$( echo "${Difficulty}" | sed -e 's/ //g' )
                grep -v Difficulty oc_car.conf > tempdatei;
                mv tempdatei oc_car.conf;
                echo "Difficulty=\"${Difficulty}\"" >> oc_car.conf;;

        # Eingabe der Geländewertung.
        t*|T*)  echo "Bitte neuen Geländebereich (nur Ganzzahlen von 1 bis 5, z. B. 1-3) eingeben:";
                read Terrain;
                Terrain=$( echo "${Terrain}" | sed -e 's/ //g' )
                grep -v Terrain oc_car.conf > tempdatei;
                mv tempdatei oc_car.conf;
                echo "Terrain=\"${Terrain}\"" >> oc_car.conf;;

        # Eingabe des E-Mail-Betreffs.
        b*|B*)  echo "Bitte neuen E-Mail-Betreff eingeben:";
                read subject;
                grep -v subject oc_car.conf > tempdatei;
                mv tempdatei oc_car.conf;
                echo "subject=\"${subject}\"" >> oc_car.conf;;

        # Eingabe des E-Mail-Textes.
        m*|M*)  echo "Bitte neuen E-Mail-Text eingeben:";
                read body;
                grep -v body oc_car.conf > tempdatei;
                mv tempdatei oc_car.conf;
                echo "body=\"${body}\"" >> oc_car.conf;;

        # Keine Änderung gewünscht.
        n*|N*)  echo "";
                break;;

        # Abbrechen.
        e*|E*)  clear;
                exit;;

        # Unbekannte Option -> Fehler.
        *) echo Das war wohl nichts;;
    esac
done

# Bildschirminhalt löschen.
clear
echo "Opencaching.de - Caches auf Route"

# Benutzer-ID ermitteln.
UUID=$( curl -s "https://www.opencaching.de/okapi/services/users/by_username?username=${ocUser}&fields=uuid&consumer_key=8YV657YqzqDcVC3QC9wM" )

# Überprüfen der Benutzer-ID.
if [ ${UUID:0:5} == "{\"err" ]; then
    echo "Benutzer nicht gefunden! Bitte Aufrufparameter prüfen -> z.B. ./oc_car.sh route.gpx 1.5 ka_be"
    exit
fi
echo "Benutzer wurde gefunden."

# Abruf der Route.
if [ "${gpxok}" = false ]; then
    # Keine gültige GPX-Datei übergeben -> Abruf der Route.

    # Koordinaten von Openstreetmap herunterladen.
    # `-s` = silent mode.
    StartJson="$( curl -s "https://nominatim.openstreetmap.org/search?q=$Start&format=json" )"
    ZielJson="$( curl -s "https://nominatim.openstreetmap.org/search?q=$Ziel&format=json" )"

    # Mit JSON.sh verarbeiten.
    StartJson="$( echo "${StartJson}" | ./JSON.sh )"
    ZielJson="$( echo "${ZielJson}" | ./JSON.sh )"

    # Zuerst suche ich in der Variable eine Zeile mit [0,"lat"] bzw. [0,"lon"], dann entferne ich dies zusammen mit den
    # Anführungszeichen, um den Koordinatenwert zu erhalten.
    latS=$(awk '{print $1}' <<< $(echo "$StartJson" | grep '\[0,"lat"\]' | sed -e 's/\[0,"lat"\]//' -e 's/"//g'))
    lngS=$(awk '{print $1}' <<< $(echo "$StartJson" | grep '\[0,"lon"\]' | sed -e 's/\[0,"lon"\]//' -e 's/"//g'))
    echo "lng:${lngS}"
    echo "lat:${latS}"
    latZ=$(awk '{print $1}' <<< $(echo "$ZielJson" | grep '\[0,"lat"\]' | sed -e 's/\[0,"lat"\]//' -e 's/"//g'))
    lngZ=$(awk '{print $1}' <<< $(echo "$ZielJson" | grep '\[0,"lon"\]' | sed -e 's/\[0,"lon"\]//' -e 's/"//g'))
    echo "lng:${lngZ}"
    echo "lat:${latZ}"

    # Die Route wird über YourNavigation abgerufen und in die Datei route.kml gespeichert.
    curl -s "http://www.yournavigation.org/api/1.0/gosmore.php?flat=${latS}&flon=${lngS}&tlat=${latZ}&tlon=${lngZ}&v=motorcar&fast=1" > ./route.kml

    # Überprüfen der GPX-Datei (konvertierte KML-Datei).
    gpsbabel -i kml -f route.kml -o gpx -F route.gpx
    if gpsbabel -i gpx -f route.gpx -o gpx -F - > /dev/null; then
        echo "GPX-Datei ist gültig"
    else
        echo "GPX-Datei ist ungültig! Der Download der Route ist fehlgeschlagen."
        exit
    fi
fi

# Überprüfen des Radius.
if [ $(echo " ${Radius} > 0" | bc) -eq 1 ]; then
    if [ $(echo " ${Radius} < 10.1" | bc) -eq 1 ]; then
        echo "Radius ist ok"
    else
        echo "Radius muss zwischen 0 und 10.1 liegen! Bitte Parameter prüfen."
        exit
    fi
else
    echo "Radius muss zwischen 0 und 10.1 liegen! Bitte Parameter prüfen."
    exit
fi

# Rechts 2 Zeichen abschneiden.
UUID=${UUID%??}
# Links 9 Zeichen abschneiden.
UUID=${UUID#?????????}
echo

# Error und distance sind Parameter für die Bearbeitung der Route und zum Festlegen der Koordinaten für die jeweilige
# Umkreissuche.
# circle ist die maximale Breite des Korridors.
# Bei einem Verhältnis error/circle ~1/4 und distance/circle ~ 5/4 ergibt dass eine Mindestabdeckung von ca. 2/3 von
# circle.
error="0"$( echo "scale=2; ${Radius} / 4" | bc )"k" # Douglas-Peucker tolerance
distance="0"$(echo "scale=2; ${Radius} / 4 * 5" | bc)"k" # interpolation distance
circle=$Radius # Suchradius in km

echo "Der max. Abstand zur festgelegten Route beträgt "$(echo "scale=3; ${circle} / 2" | bc)"km."
echo "Alle "${distance}"m wird eine neue OC.de-Abfrage durchgeführt."
echo "Zur Glättung der Route wird der Wert "${error}"m genutzt."
echo
echo "Das kann jetzt ein paar Sekunden dauern..."

# gpsbabel zum Glätten und Berechnen der Koordinaten für die jeweilige Umkreissuche.
if [ "${gpxok}" == true ]; then
    searchargs=$(
        cat $input |
        gpsbabel -i gpx -f - \
            -x simplify,crosstrack,error=$error \
                -o gpx -F - |
        gpsbabel -i gpx -f - \
            -x interpolate,distance=$distance \
                -o csv -F - |
        tr ',' ' ' |
        awk '{printf("%.3f,%.3f|",$1,$2)}'
    )
else
    searchargs=$(
        cat route.gpx |
        gpsbabel -i gpx -f - \
            -x simplify,crosstrack,error=$error \
                -o gpx -F - |
        gpsbabel -i gpx -f - \
            -x interpolate,distance=$distance \
                -o csv -F - |
        tr ',' ' ' |
        awk '{printf("%.3f,%.3f|",$1,$2)}'
    )
fi


echo "Punkte auf der Route wurden berechnet!"
echo
echo "An diesen Punkten wird mit einem Radius von "${circle}"km nach OC-Dosen gesucht:"
echo "Das kann jetzt ein paar Sekunden dauern..."
echo

# Hier wird aus dem Format Lat,Lon|Lat,Lon -> Lat|Lon,Lat|Lon.
b="$(echo "${searchargs}" | sed 's/'\|'/'a'/g')"
c="$(echo "${b}" | sed 's/'\,'/'\|'/g')"
d="$(echo "${c}" | sed 's/'a'/'\,'/g')"

# Hier werden aus dem String die einzelnen Koordinatenpaare in ein Array geschrieben.
IFS=',' read -a array <<< "${d}"

for index in "${!array[@]}"; do
    echo -n
done

# Variablen festlegen für die Fortschrittsanzeige.
coords="${#array[@]}"
echo " Prozent - Anzahl Listings"
echo
prozent=0

# Hier finden die einzelnen Abfragen statt, der Consumer_key kann bei http://www.opencaching.de/okapi/signup.html
# besorgt werden.
ArtenGross=$(echo "${Arten}" | tr [:lower:] [:upper:]) # in Großbuchstaben umwandeln
for index in "${!array[@]}"; do
    # Arten anhängen.
    if [ "${ArtenGross}" == "ALLE" ]; then
        nearestJson=$( curl -s "https://www.opencaching.de/okapi/services/caches/search/nearest?center=${array[index]}&radius=${circle}&difficulty=${Difficulty}&terrain=${Terrain}&status=Available&consumer_key=8YV657YqzqDcVC3QC9wM")
    else
        nearestJson=$( curl -s "https://www.opencaching.de/okapi/services/caches/search/nearest?center=${array[index]}&radius=${circle}&type=${Arten}&difficulty=${Difficulty}&terrain=${Terrain}&status=Available&consumer_key=8YV657YqzqDcVC3QC9wM" )
    fi

    # Wenn weniger als 30 Zeichen zurückkommen, war in diesem Bereich keine Dose versteckt.
    if [ ${#nearestJson} -lt 30 ]; then
        # Nichts tun.
        :
    else
        # Ansonsten den Ausgabestring bearbeiten.
        # Rechts 16 Zeichen abschneiden (`"],"more":false}`).
        nearestJson=${nearestJson%????????????????}

        # Links 13 Zeichen abschneiden (`{"results":["`).
        nearestJson=${nearestJson#?????????????}

        # Hier werden die " entfernt und das Komma gegen ein Leerzeichen getauscht.
        aktuelleCodes="$( echo "${nearestJson}" | sed 's/\"//g' )"
        aktuelleCodes="$( echo "${aktuelleCodes}" | sed 's/'\,'/'\ '/g' )"
        aktuelleCodes="${aktuelleCodes} "

        # In der Variable $alle werden alle ermittelten OC-Codes gespeichert.
        alle="${alle}${aktuelleCodes} "
        alle="${alle%?}"
    fi

    # Fortschritt.
    anzahl="$( echo "${alle}" | wc -w )"
    prozent=$( echo "scale=9;${prozent} + 100 / ${coords}" | bc)
    echo -en "\r${prozent} % - ${anzahl}"
done

echo

# Hier werden Duplikate aus dem String gefiltert.
alleGefiltert="$( echo "${alle}" | xargs -n 1 | sort -u | xargs )"
echo -n "Gefundene Listings ohne Duplikate: "
zahl=$( echo "${alleGefiltert}" | wc -w )
echo "${zahl}"

# Anzahl Abrufe zu je 500 bestimmen.
loop=$(($zahl / 500))

for (( c=0; c<=$loop; c++ )); do
    # `spalte` entspricht dem Startindex der aktuellen Iteration.
    spalte=$[($c * 500) + 1]

    # Der aktuelle Teil der Codes.
    codes=$( echo "${alleGefiltert}" | cut -d " " -f "${spalte}-$(($spalte+499))" )

    # Die auszugebende Geocache-GPX-Datei bestimmen -> Format `(YYMMDD-HHMMSS)PQ.gpx`.
    output="$(date "+%y%m%d-%H%M%S")PQ.gpx"

    # Jetzt werden die | zwischen die OC-Codes eingefügt und der OKAPI-Aufruf durchgeführt.
    codes="$( echo "${codes}" | sed 's/'\ '/'\|'/g' )"
    gpxAusgabe=$( curl -s "https://www.opencaching.de/okapi/services/caches/formatters/gpx?cache_codes=${codes}&consumer_key=8YV657YqzqDcVC3QC9wM&ns_ground=true&latest_logs=true&mark_found=true&user_uuid=$UUID" )
    echo "${gpxAusgabe}" >> $output
    echo "Die Datei ${output} wird hier im Verzeichnis abgelegt und per E-Mail versendet."

    # Per E-Mail versenden.
    sendemail -f $sender -t $receiver -o $tls -s $smtp -xu $mailuser -xp $mailpassword -u $"${subject} GPX$[($c + 1)] von $[(${loop} + 1)]" -m ${body} -a ${output}
done

exit
