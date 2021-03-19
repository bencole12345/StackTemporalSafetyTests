#!/bin/bash

for test_binary in build/*; do
    if [ $(./emulate.sh $test_binary | grep "SUCCESS") ]
    then
        echo "PASS: $test_binary" 
    else
        echo "FAIL: $test_binary"
    fi
done
