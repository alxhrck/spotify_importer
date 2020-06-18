#!/bin/bash
#
# Get the Spotify ID of a list of artist - album.
# Jun 2020
# ./search_artist_id.sh file

# Get a temp token from https://developer.spotify.com/console/
TOKEN=""

FILE=$1

while IFS= read -r a_line
 do
   
   line=($(echo -n ${a_line} |sed -e 's/[[:space:]]\-[[:space:]]/\-/g'| sed -e 's/[[:space:]]*$//'| sed -e 's/[[:space:]]/%20/g' | awk -F"-" '{print $1 " " $2}'))
   artist=${line[0]}
   album=${line[1]}
   resp=$(curl -s -X "GET" "https://api.spotify.com/v1/search?q=album%3A$album%20artist%3A$artist&type=album&limit=1" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN")

   album=$(echo -e $resp |  jq '.[].items[]| .artists[].name+":"+.name+":"+.id' 2> /dev/null | tr -d "\"")
   if [[ $resp =~ 'error' ]]
   then
     echo $resp
     exit 1
   else
     if [[ ! -z $album ]]
     then
       echo $album
     else
       echo $a_line":"
     fi
   fi
   
   sleep 1
 done < $FILE
