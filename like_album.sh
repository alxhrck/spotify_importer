#!/bin/bash
#
# Jun 2020


# Get a temp token from https://developer.spotify.com/console/
TOKEN=""

FILE=$1

while IFS= read -r a_line
 do
   album=$(echo $a_line | egrep -o [a-zA-Z0-9]{22})
   if [[ ! -z album ]]
   then
     resp=$(curl -s -X "PUT" "https://api.spotify.com/v1/me/albums?ids=$album" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN")
   else
     exit 1
   fi
   
   sleep 1
 done < $FILE