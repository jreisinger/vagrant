#!/bin/bash

rails new -f TestApp
cd TestApp
if [[ -e tmp/pids/server.pid ]]; then
    kill $(cat tmp/pids/server.pid)
fi
rails s -d -b 0.0.0.0
