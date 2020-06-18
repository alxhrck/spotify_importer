#!/bin/bash
#
# Get the Spotify ID of a list of artists,
# Jun 2020
# ./search_artist_id.sh file

# Get a temp token from https://developer.spotify.com/console/
TOKEN=""

FILE=$1

while IFS= read -r a_line
 do
   if echo $a_line | egrep [a-zA-Z0-9]{22}
   then
     resp=$(curl -s -X "PUT" "https://api.spotify.com/v1/me/following?type=artist&ids=$a_line" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN")
     echo $resp
   else
     exit 1
   fi
   
   sleep 1
 done < $FILE
