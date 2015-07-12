#!/bin/bash

if (( $# != 3 )); then
    echo 'Illegal number of parameters! Three parameters are needed: login, server (ip:port), database name.'
    exit 0
fi

echo -n Password: 
read -s password
echo 

if [ ! -d "$3" ]; then
  mkdir -v "$3"
  mkdir -v "$3/table"
  mkdir -v "$3/view"
  mkdir -v "$3/trigger"
  mkdir -v "$3/procedure"
fi

export LANG=en_US.UTF-8

echo 'Creating scripts for ddlgen..'

isql -Jutf8 -U$1 -P$password -S$2 -D$3 -w 2048 -i procedure.sql | sed -e '/---/d' > procedure-export.sh
isql -Jutf8 -U$1 -P$password -S$2 -D$3 -w 2048 -i table.sql     | sed -e '/---/d' > table-export.sh
isql -Jutf8 -U$1 -P$password -S$2 -D$3 -w 2048 -i view.sql      | sed -e '/---/d' > view-export.sh
isql -Jutf8 -U$1 -P$password -S$2 -D$3 -w 2048 -i trigger.sql   | sed -e '/---/d' > trigger-export.sh

chmod +x *-export.sh

echo 'Done.'

export LANG=ru_UA.UTF-8

echo 'Generating DDL for tables..'
sh table-export.sh $1 $password $2 $3
echo 'Done.'

echo 'Generating DDL for views..'
sh view-export.sh $1 $password $2 $3
echo 'Done.'

echo 'Generating DDL for triggers..'
sh trigger-export.sh $1 $password $2 $3
echo 'Done.'

echo 'Generating DDL for procedures..'
sh procedure-export.sh $1 $password $2 $3
echo 'Done.'

./clear.sh
