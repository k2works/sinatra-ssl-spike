#!/bin/bash
service nginx start
bundle exec unicorn -c unicorn.conf -D

while true
do
    sleep 10
done
