#!/bin/bash

if (( $# != 4 )); then
    echo 'Illegal number of parameters! Four parameters are needed: login, server (ip:port), source database name, target database name.'
    exit 0
fi

echo -n Password: 
read -s password
echo

export LANG=en_US.UTF-8

echo 'Creating scripts for isql..'

find $3/table/*     | awk '{print "isql -Jutf8 -U$1 -P$2 -S$3 -D$4 -i "$0" >> table.log"}'     > table-import.sh
find $3/view/*      | awk '{print "isql -Jutf8 -U$1 -P$2 -S$3 -D$4 -i "$0" >> view.log"}'      > view-import.sh
find $3/trigger/*   | awk '{print "isql -Jutf8 -U$1 -P$2 -S$3 -D$4 -i "$0" >> trigger.log"}'   > trigger-import.sh
find $3/procedure/* | awk '{print "isql -Jutf8 -U$1 -P$2 -S$3 -D$4 -i "$0" >> procedure.log"}' > procedure-import.sh

chmod +x *-import.sh

echo 'Done.'

for i in {1..2} 
do
   echo '-- Iteration '$i' --'

   echo 'Creating tables..' 
   ./table-import.sh $1 $password $2 $4
   echo 'Done.'

   echo 'Creating views..'
   ./view-import.sh $1 $password $2 $4
   echo 'Done.'

   echo 'Creating triggers..'
   ./trigger-import.sh $1 $password $2 $4
   echo 'Done.'

   echo 'Creating procedures..'
   ./procedure-import.sh $1 $password $2 $4
   echo 'Done'
done

./clear.sh
