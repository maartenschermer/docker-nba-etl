#!/bin/sh

while true
do
    echo $(date)
    curl -s 'elasticsearch:9200/_cat/indices/nba?v'
    sleep 600
done
