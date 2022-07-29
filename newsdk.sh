#!/usr/bin/env bash

cd ~/.furhat/launcher/SDK/2.3.0
steam-run bin/furhatos &

PID=$!

sleep 3

xdg-open http://localhost:8080

wait $PID
