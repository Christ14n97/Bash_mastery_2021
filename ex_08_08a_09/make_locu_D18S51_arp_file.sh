#!/bin/bash

./create_arpfile_D18S51.sh 
./extract_matrices_D18S51.sh 
./computediffpop_D18S51.sh

rm locus_D18S51.arp locus_D18S51.dist locus_D18S51.sign
