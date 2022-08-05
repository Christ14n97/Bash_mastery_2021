#!/bin/bash

#last version
cat table.data | cut -f 1,2 | grep -v "–" > significant_alleles_locus_1.data 

#--------

#creating the sample
touch new_sample
echo "SampleName='Huelva-Spain'" > new_sample
echo "SampleSize=114" >> new_sample 
echo "SampleData={" >> new_sample
cat significant_alleles_locus_1.data | tail -n 7 >> new_sample
echo "}" >> new_sample

#creating the header
echo -e '[Profile] \n\tTitle="All samples at Gibraltar for locus D3S1258" \n\tNbSamples=21 \n\tDataType=FREQUENCY \n\tGenotypicData=0 \n\tFrequency=REL \n[Data] \n[[Samples]]' > header 

#obtaining the file "locus_D3S1358.arp" ----with sed----
cat dataset_D3S1358.arp new_sample | sed "s/NbSamples=20/NbSamples=21/" > locus_D3S1358.arp

#using arlecore
arlecore locus_D3S1358.arp FstSettings.ars

#removing tmp files
rm new_sample
rm header
rm significant_alleles_locus_1.data
