#!/usr/bin/env bash

if [ ! -d GestureCapture ] ; then
    wget https://furhat-files.s3.eu-west-1.amazonaws.com/gesturecapture/FurhatGestureCapture_linux64.zip
    unzip -d GestureCapture FurhatGestureCapture_linux64.zip
    rm FurhatGestureCapture_linux64.zip
fi

nix-shell gesture-capture.nix
