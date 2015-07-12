#!/bin/bash

function ask() {
   read -p "$1 ([y]es or [N]o): "
   case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
       y|yes) echo "yes" ;;
       *)     echo "no" ;;
   esac
}

if [[ "no" == $(ask "Do you want to delete all generated scripts and logs?") || \
      "no" == $(ask "Are you *realy* sure?") ]]
then
    echo "Exit."
    exit 0
fi

echo "Deleteing files..."

rm -f -v ./*-export.sh
rm -f -v ./*-import.sh
rm -f -v ./*.log

echo "Done."
