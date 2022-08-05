#!/bin/bash

#stablishing the principal WD
startdir=$PWD

#extracting the date for directory
datecompressed=$(date | sed -e 's/ //g' -e 's/://g')

#creating a personal, tmp working directory
workingdir=/tmp/${USER}_${datecompressed} #for ex_15 add {name locus here}
mkdir $workingdir

#copying data need to the tmp working directory
cp AmovaSettings.ars ${workingdir}/AmovaSettings.ars

#running awk, obtaining the structure file directly in the working directory
awk -f MakeStructure.awk locus_CSF1PO.arp > str_tmp
cat locus_CSF1PO.arp str_tmp > ${workingdir}/locus_CSF1PO_struct.arp

#running arlecore
cd $workingdir
arlecore locus_CSF1PO_struct.arp AmovaSettings.ars

#extracting the xml file to the starting directory
cp locus_CSF1PO_struct.res/locus_CSF1PO_struct.xml ${startdir}/locus_CSF1PO_struct.xml

#removing files
rm *.out
