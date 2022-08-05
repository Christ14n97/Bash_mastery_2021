#!/bin/bash

#declaring parameter, is the column index
locus=$1

#last version
cat table.data | cut -f 1,$locus | grep -v "–" > significant_alleles_locus_1.data 

#stablishing a variable with the name of the allele
name=$(cat table.data | tr -s  " " "\t" | cut -f $locus | grep -v – | head -n 1)


#creating the sample
touch new_sample
echo "SampleName='Huelva-Spain'" > new_sample
echo "SampleSize=114" >> new_sample 
echo "SampleData={" >> new_sample
cat significant_alleles_locus_1.data | tail -n 7 >> new_sample
echo "}" >> new_sample

#declaring the variables with the number of samples before and after
n_samples=$(grep NbSamples dataset_${name}.arp | cut -d '=' -f 2)
n_samplestotal=$((n_samples + 1))

#obtaining the file "locus_${name}.arp" ----with sed----
## modifying the number of samples with the previously declared var.
cat dataset_${name}.arp new_sample | sed "s/NbSamples=${n_samples}/NbSamples=${n_samplestotal}/" > locus_${name}.arp

#using arlecore
arlecore locus_${name}.arp FstSettings.ars

#removing tmp files
rm new_sample significant_alleles_locus_1.data

#running the next bash script and passing the variable name as parameter 
./extract_matrices.sh $name
