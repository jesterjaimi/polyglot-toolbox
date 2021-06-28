#!/usr/bin/env bash
# parse todays date.
#date=$(date -d "1 day ago" +"%Y-%m-%d %H:%M:%S")
#date=$(date -date='1 day ago' +'%Y-%m-%d %H:%M:%S')
#_date=$(date -d @$(( $(date +"%s") - 86400)) +"%Y-%m-%d %H:%M:%S")
#_date=$(date -v-1d +%F)
_date=$(TZ=EST23ETD date +"%Y-%m-%d %H:%M:%S")
echo "_date : $_date"
read Y M D h m s <<< ${_date//[-: ]/ }
_date_str="$Y-$M-$D"
#echo $_date_str
echo "date: $_date_str"
