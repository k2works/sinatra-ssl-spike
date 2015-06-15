#!/bin/bash
service nginx start
bundle exec puma --config config/puma.rb -d

while true
do
    sleep 10
done
