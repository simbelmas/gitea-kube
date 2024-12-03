#!/bin/sh -e
cm_ini_path=/mnt/app.ini
cm_md5=$(md5sum $cm_ini_path | cut -f1 -d ' ')
custom_ini_path=/app/custom/conf/app.ini
if [ ! -e "$custom_ini_path" ] ; then
  echo app.ini file does not exists, copying it
  (
    set -x
    mkdir -p $(dirname $custom_ini_path)
    cp $cm_ini_path $custom_ini_path
  )
else
  current_md5=$(md5sum $custom_ini_path | cut -f1 -d ' ')
  if [ "$current_md5" != "$cm_md5" ] ; then
    echo "cm ini file md5 ($cm_md5) differs from current config file ($current_md5). Updating ..."
    cp -fv $cm_ini_path $custom_ini_path
  fi
fi
db_connect_retries=20
db_current_try=0
until echo '\n' | nc -w 5 mariadb.mariadb.svc.cluster.local 3306 ; do
  echo "Waiting for mariadb start. retry $db_current_try of $db_connect_retries"
  db_current_try=$((db_current_try+1))
  if [ $db_current_try -eq $db_connect_retries ] ; then
    exit 1
  fi
  sleep 2
done