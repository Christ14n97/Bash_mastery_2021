#!/bin/bash

# The lab file contains the name of the population as rows with it respective index.
## First I cut the index using the *complement* option of *cut*, hence the column that matches is excluded.
## Then, I squeezed and substituted the spaces for an underscore to have the same format in all the labels.
cat locus_CSF1PO.lab | cut --complement -f 1 | tr -s ' ' '_'  > lab_tmp

# I used *paste -s* to merge lines serially, thus I had the labels in only one line.
paste -s lab_tmp > lab_tmp_2

# Modifying dist matrix by switching from one or more spaces *\s+* to tab *\t*
cat locus_CSF1PO.dist | sed -E 's/\s+/\t/g' > dist_tmp

# Opening both tmp files and saving then into a new file to have labels on top of the matrix.
cat lab_tmp_2 dist_tmp > locus_CSF1PO_raw

# Performing last modification by substituting negative zeros, *-0.0* for *0.0*.
cat locus_CSF1PO_raw | sed -E 's/-0.0+/0.0/g' > locus_CSF1PO.mat

# Removing tmp files.
rm lab_tmp lab_tmp_2 dist_tmp locus_CSF1PO_raw

# Running R script
Rscript make_MDS.R 
