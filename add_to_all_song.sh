#!/bin/bash
#
# Jun 2020


# Get a temp token from https://developer.spotify.com/console/
#TOKEN=""

NEXT="https://api.spotify.com/v1/me/albums?limit=1&offset=0"

while [[ "$NEXT" != "null" || -n "$NEXT" ]]
do 
  resp=$(curl -s -X "GET" "$NEXT" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN")
  if [[ $resp == *"error"* ]]; then
    echo $resp
    exit 1
  fi
  echo $resp | jq -r '.items[].album.name'
  tracks=$(echo $resp | jq -r '.items[].album.tracks.items[]| .uri'|tr '\n' ',')
  NEXT=$(echo $resp | jq -r '.next')
  #echo $NEXT
  curl -s -X "POST" "https://api.spotify.com/v1/playlists/0jI1jO1M2D4lGMIYV88Fic/tracks?uris=$tracks" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN"

  sleep 2

done

echo "bye"
exit 1
