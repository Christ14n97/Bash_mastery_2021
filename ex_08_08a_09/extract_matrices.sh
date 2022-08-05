#!/bin/bash

#declaring parameter
name=$1

#echo ${name}
#---Labels
cat locus_${name}.res/locus_${name}.xml | sed -n "/<\/data> <pairDistPopLabels/,/<\/pairDistPopLabels> <data>/ p" | tail -n +5| head -n +21 > locus_${name}.lab
rm locus_${name}.lab

#---Distancies
cat locus_${name}.res/locus_${name}.xml | sed -n "/<\/data> <coancestryCoefficients/,/<\/coancestryCoefficients> <data>/ p" | tail -n +4 | head -n 22 > tmp_dist
cat tmp_dist | tr -s ' '| cut -d ' ' --complement -f 1,2 > locus_${name}.dist

#---Significance
cat locus_${name}.res/locus_${name}.xml | sed -n "/Matrix of significant Fst/,/Matrix of coancestry coefficients/p"  > tmp_sign
cat tmp_sign | head -n -3 | tail -n +8 |tr -s ' ' | cut -d ' ' --complement -f 1,2 > locus_${name}.sign 

#removing tmp files
rm tmp_dist tmp_sign

#running next script with name as parameter
./computediffpop.sh $name
