#!/bin/sh

for SEASON in $(curl -s 'https://lscluster.hockeytech.com/feed/index.php?feed=statviewfeed&view=bootstrap&season=1&game_id=&pageName=schedule&key=694cfeed58c932ee&client_code=pwhl&site_id=2&league_id=1&league_code=&lang=en' | jq -R -s -r '.[1+index("("): rindex(")")] | fromjson | .seasons[].id');

do
 URL="https://lscluster.hockeytech.com/feed/index.php?feed=statviewfeed&view=schedule&team=-1&season=${SEASON}&month=-1&location=homeaway&key=694cfeed58c932ee&client_code=pwhl&site_id=2&league_id=1&division_id=-1&lang=en"
 echo "fetching $URL"
 curl -s $(curl -s "$URL" | jq -R -s -r '.[1+index("("): rindex(")")] | fromjson | .[0].sections[0].data | .[] | select(.prop.mobile_calendar) | .prop.mobile_calendar.link') | awk -v ORS="\r\n" -v FS=: -v OFS=: 'BEGIN { printf "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//Hockeytech//Leaguestat iCal//EN\r\nMETHOD:PUBLISH\r\n";} END {printf "END:VCALENDAR\r\n";} /^BEGIN:VEVENT/{flag=1};$1 == "DESCRIPTION" {$2="https://www.youtube.com/@thepwhlofficial/streams"}; flag;/^END:VEVENT/{flag=0}' > season-$SEASON.ical
done
