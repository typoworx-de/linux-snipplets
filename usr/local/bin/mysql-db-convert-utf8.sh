#!/bin/bash

if [[ -z "$1" ]];
then
  echo "Syntax: $0 [dbname] -h {database-host} -u {user} -p {password}";
  exit;
fi

dbName="$1";

echo "[*] Creating Backup-Dump";
if [[ -f "${dbName}.sql.bz2" ]];
then
  echo "[i] MySQL Dump for Database ${dbName} already exists.";
else
  mysqldump ${dbName} --opt ${@:2} | bzip2 > ${dbName}.sql.bz2 || {
    echo "[x] Error Creating Backup-Dump for Database ${dbName}!";
    exit;
  }
fi

echo "[*] Processing database convert to UTF-8";
mysql --database=${dbName} -B -N -e "SHOW TABLES" ${@:2} | \
  awk '{print "ALTER TABLE", $1, "CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;"}' | \
  mysql --database=$dbName ${@:2} \
;
