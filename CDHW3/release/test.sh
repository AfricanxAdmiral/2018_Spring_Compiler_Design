#!/bin/bash                                                                     

input=`find input/ -name *.p`

for filename in $input; do
        echo $filename
        basename=`basename $filename`
            ./parser $filename  > output/$basename.out
        done
