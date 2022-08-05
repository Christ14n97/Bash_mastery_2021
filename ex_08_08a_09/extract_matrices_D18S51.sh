#!/bin/bash

#---Labels
cat locus_D18S51.res/locus_D18S51.xml | sed -n "/<\/data> <pairDistPopLabels/,/<\/pairDistPopLabels> <data>/ p" | tail -n +5| head -n +21 > locus_D18S51.lab
rm locus_D18S51.lab

#---Distancies
cat locus_D18S51.res/locus_D18S51.xml | sed -n "/<\/data> <coancestryCoefficients/,/<\/coancestryCoefficients> <data>/ p" | tail -n +4 | head -n 22 > tmp_dist
cat tmp_dist | tr -s ' '| cut -d ' ' --complement -f 1,2 > locus_D18S51.dist

#---Significance
cat locus_D18S51.res/locus_D18S51.xml | sed -n "/Matrix of significant Fst/,/Matrix of coancestry coefficients/p" > tmp_sign
cat tmp_sign |  head -n -3 | tail -n +8 | tr -s ' ' | cut -d ' ' --complement -f 1,2 > locus_D18S51.sign 

rm tmp_dist tmp_sign
