#!/bin/bash
# Make a backup set of files
echo 'foo'
lines=$( ls $1/* | wc -l )
if [ $lines -gt 0 ]
then
    echo 'bar'
    dirx=$( ls -l $1/backup/* | wc -l )
    echo "dirx=$dirx"
    if [ $dirx -lt 1 ]
    then 
        mkdir -p $1/backup/
    fi

    for value in $1/*
    do
        used=$( df $1 | tail -1 | awk '{ print $5 }' | sed 's/%//' )
        if [ $used -gt 90 ]
        then
            echo Low disk space 1>&2
            break
        fi
        cp -f $value $1/backup/
    done
fi
echo 'baz'