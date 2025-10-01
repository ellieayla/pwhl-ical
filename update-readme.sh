#!/bin/sh


cp README.tmpl README.md

for filename in `ls -r season-*.ical`
do
	export ROWS=$(echo $(cat $filename | wc -l))
	if [[ "$ROWS" -gt "5" ]]; then
		echo " * [$filename](webcal://github.com/$GITHUB_REPOSITORY/raw/refs/heads/main/$filename)" >> README.md
	else
		echo " * $filename finished." >> README.md
	fi
done
