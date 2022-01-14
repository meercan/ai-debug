#!/bin/bash

kernel=$(uname -s)

if [[ $kernel == "Linux" ]]; then
    cp -a ./. /home/ubuntu/
fi
