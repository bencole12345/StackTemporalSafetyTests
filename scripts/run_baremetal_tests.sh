#!/bin/bash

for test_binary in build/baremetal/*; do
    if [ $(scripts/run_sail_emulator.sh $test_binary | grep "SUCCESS") ]
    then
        echo "PASS: $test_binary" 
    else
        echo "FAIL: $test_binary"
    fi
done
