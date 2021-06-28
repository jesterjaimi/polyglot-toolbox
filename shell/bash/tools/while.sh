#!/bin/bash
# Basic while loop
counter=1
while [ $counter -le 10 ]
do
echo "Hello World$counter"
((counter++))
done
echo All done