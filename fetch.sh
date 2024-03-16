#!/bin/sh

echo "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//Hockeytech//Leaguestat iCal//EN\nBEGIN:VCALENDAR";
curl -s $(curl -s https://lscluster.hockeytech.com/feed/index.php\?feed\=statviewfeed\&view\=schedule\&team\=-1\&season\=1\&month\=3\&location\=homeaway\&key\=694cfeed58c932ee\&client_code\=pwhl\&site_id\=2\&league_id\=1\&division_id\=-1\&lang\=en | jq -R -s -r '.[1+index("("): rindex(")")] | fromjson | .[0].sections[0].data | .[] | select(.prop.mobile_calendar) | .prop.mobile_calendar.link') | awk -v FS=: -v OFS=: '/^BEGIN:VEVENT/{flag=1};$1 == "DESCRIPTION" {$2="https://www.youtube.com/@thepwhlofficial/streams"}; flag;/^END:VEVENT/{flag=0}'
echo "END:VCALENDAR"
