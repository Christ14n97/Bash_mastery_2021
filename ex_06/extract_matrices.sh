#!/bin/bash


#---Labels
cat locus_D3S1358.xml | sed -n "/<\/data> <pairDistPopLabels/,/<\/pairDistPopLabels> <data>/ p" | tail -n +5| head -n +21 > locus_D3S1358.lab


#---Distancies
 cat locus_D3S1358.xml | sed -n "/<\/data> <coancestryCoefficients/,/<\/coancestryCoefficients> <data>/ p" | tail -n +3 | head -n 22 > locus_D3S1358.dist

#---Significance
cat locus_D3S1358.xml | sed -n "196,217 p" > locus_D3S1358.sign
