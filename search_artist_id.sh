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
   line=$(echo -e ${a_line} | sed -e 's/[[:space:]]*$//'| sed -e 's/[[:space:]]/%20/g')
   resp=$(curl -s -X "GET" "https://api.spotify.com/v1/search?q=$line&type=artist&limit=1" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN")
   artist=$(echo -e $resp | jq '.[].items[]| .name + ":" + .id' 2> /dev/null | tr -d "\"")
   if [[ $resp =~ 'error' ]]
   then
     echo $resp
     exit 1
   else
     if [[ ! -z $artist ]]
     then
       echo $artist
     else
       echo $a_line":"
     fi
   fi
   
   sleep 1
 done < $FILE
