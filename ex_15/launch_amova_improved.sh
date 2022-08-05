#!/bin/bash

#stablishing starting WD
startdir=$PWD

#extracting the date for directory
datecompressed=$(date | sed -e 's/ //g' -e 's/://g')



#creating a personal, tmp WD for each of the locus in starting WD
#I'm trying to use an array containing all the name to iterate with a 
#for loop so I don't need to create a tmp file
locus=($(ls *.arp | sed -e 's/locus_//' -e 's/.arp//'))


for l in ${locus[@]}; do

	workingdir=/tmp/${USER}_${datecompressed}_${l}
	mkdir $workingdir
	
	#copying data need to the tmp WD
	cp AmovaSettings.ars ${workingdir}/AmovaSettings.ars
	
	#running awk, obtaining the structure file directly in the WD
	awk -f MakeStructure.awk locus_${l}.arp > str_tmp
	cat locus_${l}.arp str_tmp > ${workingdir}/locus_${l}_struct.arp

	#switching to wd and running arlecore
	cd $workingdir
	arlecore locus_${l}_struct.arp AmovaSettings.ars

	#extracting the xml file to the starting WD
	cp locus_${l}_struct.res/locus_${l}_struct.xml ${startdir}/locus_${l}_struct.xml

    #removing tmp files
    rm *_tmp
done













