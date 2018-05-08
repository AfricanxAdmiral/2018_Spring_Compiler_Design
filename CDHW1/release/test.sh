#!/bin/bash

input=`find input/`

for filename in input/*.p; do
    basename=`basename $filename`
	./scanner $filename  > output/$basename.out
done
