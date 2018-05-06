#!/bin/bash

i=1
while [ $i=1 ]
do
Values=$("AdafruitDHT")
now=$(($(date +%s%N)/1000000))

MIXARRAY=( $Values )
TEMPERATURE=$(echo "${MIXARRAY[0]} - 3" | bc )
HUMIDITY=$(echo "${MIXARRAY[1]} + 18" | bc )

if (( $(bc <<< "$TEMPERATURE > -30") )); then
        echo "$TEMPERATURE" > /dev/shm/temp.txt
        metric1=temperature
        host=10.9.2.15
        echo "put $metric1 $now $TEMPERATURE host=A" | nc -w 30 $host 4242

fi
if (( $(bc <<< "$HUMIDITY < 100 ") )); then
        echo "$HUMIDITY" > /dev/shm/humid.txt
        metric2=humidity
        host=10.9.2.15
        echo "put $metric2 $now $HUMIDITY host=A" | nc -w 30 $host 4242
fi

sleep 60
done