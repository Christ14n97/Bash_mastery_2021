#!/bin/bash

#Obtaining list of locus names in the directory 
##Regex was used to create a group (within parenthesis)
##everything is ignored except the group at '\1'--> so cool

ls *.dist | sed -r 's/locus_(.*).dist/\1/' > l_name_tmp

#Used of a for loop on the file containing loci names to perform MDS analysis
for n in $(cat l_name_tmp); do
	
	#To obtain labels
	cat locus_${n}.lab | cut --complement -f 1 | tr -s ' ' '_'  > lab_tmp
	
	#Changing labels from one column to one row for header in the matrix
	paste -s lab_tmp > lab_tmp_2
	
	#Manipulating distance matrix to switch from space to tab
	cat locus_${n}.dist | sed -E 's/\s+/\t/g' > dist_tmp
	
	#Merging tmp labels and tmp distance to obtain only one file
	cat lab_tmp_2 dist_tmp > locus_${n}_raw
	
	#Last manipulation to get rid of '-0.000' for just '0.0'
	cat locus_${n}_raw | sed -E 's/-0.0+/0.0/g' > locus_${n}.mat
	
	#Modifying the R script to be one for each locus 
	sed "s/CSF1PO/${n}/g" make_MDS.R > make_MDS_${n}.R
	 
	#Running each of the R script
	Rscript make_MDS_${n}.R

done

#Cleaning directory from tmp files
rm lab_tmp lab_tmp_2 dist_tmp locus_${n}_raw
