#!/bin/bash

# Erstellen des Logging-Verzeichnisses und des Logfiles, falls noch nicht vorhanden
mkdir -p Logging
touch Logging/log.txt

# Funktion, die die Daten von der API abruft, formatiert und in die Ausgabedatei schreibt
function log_data {
  while true; do
    # Abrufen der Daten von der API
    data=$(curl -s http://192.168.178.48/?m=1)

    # Extrahieren der Werte
    temp=$(echo "$data" | grep -oP '(?<=DHT11 Temperatur{m})[0-9.]+')
    humid=$(echo "$data" | grep -oP '(?<=DHT11 Feuchtigkeit{m})[0-9.]+')
    dew=$(echo "$data" | grep -oP '(?<=DHT11 Taupunkt{m})[0-9.]+')

    # Formatieren als CSV-Datei
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    csv="$timestamp,$temp,$humid,$dew"

    # Anhängen an die Ausgabedatei
    echo "$csv" >> data.csv

    # Loggen der Werte in das Logfile
    echo "$timestamp: Temperatur=$temp, Luftfeuchtigkeit=$humid, Taupunkt=$dew" >> Logging/log.txt

    # Warten für 30 Sekunden
    sleep 60
  done
}

# Starten der Funktion in einem separaten Thread
log_data &

# Ausgabe des Logfiles
tail -f Logging/log.txt
