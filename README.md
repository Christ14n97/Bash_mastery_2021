# Report on Computer Skills for Biological Research Course

Computer skills for biological research course aims at bringing practical lessons to attendants so they can use comfortably GNU/Linux workstation environment, work with shells and write shell scripts, manipulate data files, convert file formats as well as automatize and repeat file manipulations.

Author: 

[Christian Peralta Viteri](https://www.linkedin.com/in/christian-peralta-viteri-71a81b16b/)

## Introduction

The course was, indeed, hard up to the point of making me think about whether I took the correct choice deciding to attend this course. Nonetheless, now I do feel more comfortable using the bash console as well as using command line to navigate, read and modify files. 

Regarding the fact of whether I can implement my new set of skills in my current workflow is something that I cannot answer right now. To be honest, the data set that we had been working with during the course is what I would describe as a "dummy data set". I describe this data set as such since the "data manipulation" that we performed  was over an unrealistic case, where the data set lack of tricky columns to struggle with; something that is completely expected as we took it from a published scientific article.

I have been trying to reproduce an R data manipulation function I use in my day-by-day workflow to assess my recently acquired skills. However, I have failed in the attempt so far.

This is the R function:

```R
pacman::p_load(tidyverse)

Clean_mscleanR <- function(path){
  df <- read_csv(path, col_names = T)
  df <- df %>%
    select(., starts_with(c("Alignment", "Control", "Exposed", "QC"))) %>%
    column_to_rownames(., "Alignment.ID")
  df <- as.data.frame(t(df))
  Exposure = c("control", "control", "control",
               "exposed","exposed","exposed", "exposed", "QC", "QC")
  df <- df %>%
    add_column(.,Exposure = Exposure, .before = 1)
}
```

And this is my bash script:

```bash
#!/bin/bash

list_name=$1
df=$2

#First squeezing muliple spaces in one
#Switching delimiter from ',' to \t to avoid future problems
cat $df | sed -E 's/\s+/ /g' | sed 's/ /\t/g' > df_tab_del

#Obtaining the indices, first as an array and then as a list
for n in $(cat list_name); do 
	index=($(cat df_tab_del | head -n 1 | tr '\t' '\n' | grep -n $n | cut -d : -f 1 | tr '\t' ','))
	echo ${index[@]} >> column_index_tmp
done

cat column_index_tmp
column=$(cat column_index_tmp | paste -d , -s | tr   ' '   ',')
echo $column

#Using variable $column as a list for cut
cat df_tab_del | cut -f $column > df_cleaned

#Removing tmp files
rm column_index_tmp
```

The main probelm is that some columns contain information such as:

```
,"ChEBI=CHEBI:41200,DrugBank=DB02982,LipidMAPS=LMFA05000007;LMFA05000196,PubChem=445128;UNPD=UNPD137952",

,"3-ethyl-1,4,5-trimethyl-1H-pyrazole",
```

Do you see the conflict? Wherever I want to manipulate this data set, bash detects all the commas thus giving me unexpected results.

One posible solution might be using AWK, however, Do I need to learn all existing programming languages? Is it worthy to use bash for my data manipulation workflow?

Hopefully, during my one year of MSc thesis I might be able to find a good use of GNU/Linux commands, there is nothing I would like the most.

----

# Day 1

## Exercise 1

In this exercise we were told to create a working directory (WD) using *mkdir* command and then I downloaded the document *Coudray_et_al_ForSciInt_07.pdf* from Moodel directly to the new WD. Thereafter, the pdf was converted to text using *pdftotext* command.

**Commands**

```bash
#Selecting just the first part of the table while maintaining its layout
## -f and -l stand for first and last page to convert
pdftotext -f 2 -l 2 -layout Coudray_et_al_ForSciInt_07.pdf table_1

#Trimming and saving the first part of the table
tail -n 35 table_1 > table_1_final

#Obtaining the continuation of table 1
pdftotext -f 3 -l 3 -layout Coudray_et_al_ForSciInt_07.pdf table_2

#Getting rid of the first and final rows
head -n 9 table_2 | tail -n 6 > table_2_final

#Merging into one DB by redirecting the standard output
cat table_1_final table_2_final > table.data_tmp

#First, squeezing the spaces, then changing the delimiters of the table
cat table.data | tr -s ' ' |tr -s ' ' '\t' > table.data

#Removing tmp files
rm table_1 table_2 table.data_tmp
```

The step where we had to change the delimiters of the table is essential; otherwise one might have to come back and correct the script. In fact, it is want happened to me and I fell back by this mistake.

## Exercise 2

In exercise 2 we had to repeat the same process, however, we were told to use pipes; thus we can save some lines of code by concatenating commands.

**Commands**

```bash
#Converting from pdf, obtaining the first part of the table and then #get rid of the first rows
pdftotext -f 2 -l 3 -layout Coudray_et_al_ForSciInt_07.pdf table_1

#Retaining the first part
head -n 45 table_1 | tail -n 35 > table.data

#Retaining the second part and adding it to table.data
head -n 54 table_1 | tail -n 6 >> table.data

#Squeezing and changing the delimiters of the table
cat table.data | tr -s ' ' |tr -s ' ' '\t'

#Remove tmp files
rm table_1
```

## Exercise 3 and 4

Now we had to create a text file in format *.arp* to be use in the software ARLEQUIN to compute the genetic distances.

Previous creation of the *.arp* file, we had to select only the column related to the locus D3S1358 where we had to remove the lines corresponding to absent alleles.

Then, we had to prepare a sample and header to be included in the final *.arp* file. This part was tricky as we had to add the header with the number of samples modified, the sample, and the other samples in a strict format.

For that reason, and as I am getting use to be lazy, I used *sed* command to modify the current header rather than creating new one.

**Commands**

```bash
#Cutting the alele of interest and save it in another file
##I used *grep -v* to select those that do not match with *' - '*.
cut -f 2 table.data > data1 | cat data1 | grep -v "-"  > significant_alleles_locus_1.data
```

<a name="arp_file"></a>

```bash
#Creating the sample
touch new_sample
echo "SampleName='Huelva-Spain'" > new_sample
echo "SampleSize=114" >> new_sample 
echo "SampleData={" >> new_sample
cat significant_alleles_locus_1.data | tail -n 7 >> new_sample

#Creating the header
## -e option stands for enabling interpretation of backslash escapes
echo -e "[Profile] \n\tTitle="All samples at Gibraltar for locus D3S1258" \n\tNbSamples=21 \n\tDataType=FREQUENCY \n\tGenotypicData=0 \n\tFrequency=REL \n[Data] \n[[Samples]]" > header 

#Obtaining the file "locus_D3S1358.arp", with sed instead of the created header
cat dataset_D3S1358.arp new_sample | sed "s/NbSamples=20/NbSamples=21/" > locus_D3S1358.arp

#Using arlecore
arlecore locus_D3S1358.arp FstSettings.ars
```

# Day 2

## Exercise 5

In exercise 5 we had to obtain two matrices and one list of labels from the result computed by ARLECORE, found in *locus_D3S1358.res/locus_D3S1358.xml*. 

The task was to obtain the labels, the genetic distance matrix as well as the significance matrix.

For this, I did not use the best approach.

**Commands**

```bash
#Labels
cat locus_D3S1358.xml | sed -n "/label/,/Huelva-Spain/ p" | tail -n +5 > locus_D3S1358.lab

#Distancies
cat locus_D3S1358.xml | sed -n "229,250 p" > locus_D3S1358.dist

#Significance
cat locus_D3S1358.xml | sed -n "194,217 p" > locus_D3S1358.sign
```

Notice that I did not use patterns, it was a similar approach as the one used in the table.data extraction.

## Exercise 6

In exercise 6 we had to develop our first scripts to automatize the two previous exercises for the locus D3S1358:

+ Creation of an *arp* file
+ Extraction of label, distance and significance matrices

To this aim, we had to develop 3 script: create_arp_file.sh, extract_matrices.sh and ex_06.sh. The latter contains the commands to run the first two scripts.

All bash script were transformed and executed using:

```bash
chmod 755 script.sh
./script.sh
```

**create_arp_file.sh**

See: [arp_file](#arp_file)

**extract_matrices.sh**

```bash
#!/bin/bash

#Labels
##This time using patterns. Watch out, we have to scape the forward slashes by using backwards slashes.
## sed -n is to avoid automatic printing and the final p is to print only what is between the patterns
cat locus_D3S1358.xml | sed -n "/<\/data> <pairDistPopLabels/,/<\/pairDistPopLabels> <data>/ p" | tail -n +5| head -n +21 > locus_D3S1358.lab

#Distancies
cat locus_D3S1358.xml | sed -n "/<\/data> <coancestryCoefficients/,/<\/coancestryCoefficients> <data>/ p" | tail -n +3 | head -n 22 > locus_D3S1358.dist

#Significance
cat locus_D3S1358.xml | sed -n "196,217 p" > locus_D3S1358.sign
```

After discussing with my classmates I found out that we had to use patterns to make it less error-prone and straightforward.

**ex_06.sh**

```bash
#!/bin/bash

./create_arp_file.sh
./extract_matrices.sh
```

## Exercise 7

In exercise 7 we were provided with a script namely *serialise_arp_tables.sh*, and we had to apply this script to both matrices files that we obtained in exercise 6. The result had to be rename to dist.1 and sign.1, that can be done by using: 

```bash
mv pop_dist.data dist.1
mv pop_sign.data sign.1
```

Now we had to do the following:

+ From sign.1 extract only those lines for which the distance is statistically significant into file sign.2
+ Merge sign.2 and dist.1 into one file using *join* command and previously sorting by the distance, from the largest to the smallest using *sort*.

**Commands**

```bash
#Getting significant significance
cat sign.1 | grep -v - > sign.2

#Sorting by key
cat sign.2 | sort -k 1,1 > sign.2.s
cat dist.1 | sort -k 1,1 > dist.1.s

#Joining
join sign.2.s dist.1.s > difpop_D3S1358.txt

#Remove tmp files
rm sign.2.s dist.1.s
```

To finish the exercise, we had to answer the following questions:

+ What is the number of population pair which are genetically differentiated?

```bash
# word count, -l stands for print the newline counts
cat difpop_D3S1358.txt | wc -l

#63 populations
```

+ Which are the two populations the most differentiated genetically?

```bash
#I passed -n to sort numerically. \\t is same as '\t'
cat difpop_D3S1358.txt | tr " ", \\t | sort -k 3 -n

#21~4 and 21~19
```

# Day 3

## Exercise 8, 8a and 9

Exercise 8 consisted of repeating the creation of an *.arp* file, label and matrices extraction and computediffpop for two more locus.

Example of bash script for **locus D21S11**:

*create_arpfile_D21S11.sh*

```bash
#!/bin/bash

#Obtaining the columns of interest
cat table.data | cut -f 1,3 | grep -v "–" > significant_alleles_locus_1.data 

#Creating the sample
touch new_sample
echo "SampleName='Huelva-Spain'" > new_sample
echo "SampleSize=114" >> new_sample 
echo "SampleData={" >> new_sample
cat significant_alleles_locus_1.data | tail -n 7 >> new_sample
echo "}" >> new_sample

#Obtaining the file "locus_D21S11.arp" ----with sed----
cat dataset_D21S11.arp new_sample | sed "s/NbSamples=20/NbSamples=21/" > locus_D21S11.arp

#Using arlecore
arlecore locus_D21S11.arp FstSettings.ars

#Removing tmp files
rm new_sample significant_alleles_locus_1.data
```

*extract_matrices_D21S11.sh*

```bash
#!/bin/bash

#Labels
cat locus_D21S11.res/locus_D21S11.xml | sed -n "/<\/data> <pairDistPopLabels/,/<\/pairDistPopLabels> <data>/ p" | tail -n +5| head -n +21 > locus_D21S11.lab

#Distancies
cat locus_D21S11.res/locus_D21S11.xml | sed -n "/<\/data> <coancestryCoefficients/,/<\/coancestryCoefficients> <data>/ p" | tail -n +4 | head -n 22 > tmp_dist
##Retaining everything exept the first two empty columns
cat tmp_dist | tr -s ' '| cut -d ' ' --complement -f 1,2 > locus_D21S11.dist

#Significance
cat locus_D21S11.res/locus_D21S118.xml | sed -n "/Matrix of significant Fst/,/Matrix of coancestry coefficients/p" > tmp_sign
cat tmp_sign | head -n -3 | tail -n +8 | tr -s ' ' | cut -d ' ' --complement -f 1,2 > locus_D21S11.sign 

#Removing tmp files
rm locus_D21S11.lab tmp_dist tmp_sign
```

*computediffpop_D21S11.sh*

```bash
#!/bin/bash

#Run serialise script and change the name
./serialise_arp_tables.sh locus_D21S11

mv pop_dist.data dist.1
mv pop_sign.data sign.1

#Getting significant significance
cat sign.1 | grep -v - > sign.2

#Sorting
cat sign.2 | sort -k 1,1 > sign.2.s
cat dist.1 | sort -k 1,1 > dist.1.s

#Joining
join sign.2.s dist.1.s > tmp
cat tmp | tr " ", \t > difpop_D21S11.txt

#Removing tmp files
rm sign.2.s dist.1.s tmp dist.1 sign.1 sign.2
```

*make_locus_D21S11_arp_file.sh*

```bash
#!/bin/bash

./create_arpfile_D21S11.sh 
./extract_matrices_D21S11.sh 
./computediffpop_D21S11.sh

```

The next step was to list the differences between the scripts for the three loci and develop a series of generic scripts where we had to include 3 parameters ($1, $2, $3) to specify the changes among the scripts such as the locus number, the number of population before and after and the column index of the locus.

However, with a classmate, we decided to use only one parameter and from there other variables will arise and will be passed as parameters for next scripts.

We decided this since it is the way we would do it for us, just caring about the column index of the locus. In addition, we both fell back due to the problem with the data frame format I mentioned at the beginning and we had to catch up.

**Commands**

*make_one_locus_arpfile.sh*

```bash
#!/bin/bash

#Here we would be passing the locus position in the table
var1=$1 
./create_arpfile.sh $var1
```

*create_arpfile.sh*

```bash
#!/bin/bash

#Declaring parameter, is the column index
locus=$1

#Extracting the information from the  table
cat table.data | cut -f 1,$locus | grep -v "–" > significant_alleles_locus_1.data 

#Stablishing a variable with the name of the allele
name=$(cat table.data | tr -s  " " "\t" | cut -f $locus | head -n 1)

#Creating the sample
touch new_sample
echo "SampleName='Huelva-Spain'" > new_sample
echo "SampleSize=114" >> new_sample 
echo "SampleData={" >> new_sample
cat significant_alleles_locus_1.data | tail -n 7 >> new_sample
echo "}" >> new_sample

#Declaring the variables with the number of samples before and after
##before
n_samples=$(grep NbSamples dataset_${name}.arp | cut -d '=' -f 2)
##after
n_samplestotal=$((n_samples + 1))

#Obtaining the file "locus_${name}.arp" ----with sed----
##Modifying the number of samples with the previously declared var.
cat dataset_${name}.arp new_sample | sed "s/NbSamples=${n_samples}/NbSamples=${n_samplestotal}/" > locus_${name}.arp

#Using arlecore
arlecore locus_${name}.arp FstSettings.ars

#Removing tmp files
rm new_sample significant_alleles_locus_1.data

#Running the next bash script and passing the variable name as parameter 
./extract_matrices.sh $name
```

*extract_matrices.sh*

```bash
#!/bin/bash

#Declaring parameter
name=$1

#Labels
cat locus_${name}.res/locus_${name}.xml | sed -n "/<\/data> <pairDistPopLabels/,/<\/pairDistPopLabels> <data>/ p" | tail -n +5| head -n +21 > locus_${name}.lab

#Distancies
cat locus_${name}.res/locus_${name}.xml | sed -n "/<\/data> <coancestryCoefficients/,/<\/coancestryCoefficients> <data>/ p" | tail -n +4 | head -n 22 > tmp_dist
cat tmp_dist | tr -s ' '| cut -d ' ' --complement -f 1,2 > locus_${name}.dist

#Significance
cat locus_${name}.res/locus_${name}.xml | sed -n "/Matrix of significant Fst/,/Matrix of coancestry coefficients/p"  > tmp_sign
cat tmp_sign | head -n -3 | tail -n +8 |tr -s ' ' | cut -d ' ' --complement -f 1,2 > locus_${name}.sign 

#Removing tmp files
rm locus_${name}.lab tmp_dist tmp_sign

#Running next script with name as parameter
./computediffpop.sh $name
```

*computediffpop.sh*

```bash
#!/bin/bash

#Declaring argument
name=$1

#Run serialise script and change the name
./serialise_arp_tables.sh locus_${name}

#Modifying the names
mv pop_dist.data dist.1
mv pop_sign.data sign.1

#Getting significant significance
cat sign.1 | grep -v - > sign.2

#Sorting
cat sign.2 | sort -k 1,1 > sign.2.s
cat dist.1 | sort -k 1,1 > dist.1.s

#Joining
join sign.2.s dist.1.s > tmp
cat tmp | tr " ", \\t > difpop_${name}.txt

#Remove tmp files
rm sign.2.s dist.1.s tmp dist.1 sign.1 sign.2
```

By this time we realised that we had done the exercise 9, modifying automatically the number of population, so we decided to finish with the optional exercise 8a.

To do this, we just applied a for loop onto a range from 2 to 16, the number of columns of the table.data excluding the first which is always present.

*make_multiple_loci_arpfile.sh*

```bash
#!/bin/bash

for i in {2..16}; do ./create_arpfile.sh $i; done
```

Now the other files are run for every locus and we just have to run one script without passing any parameter.

## Exercise 10

The purpose of exercise 10 is to practice regex by modifying scripts from exercises 8 and 9. Furthermore, we had to improve the scripts by introducing local variables whenever it was suitable.

As I had already made use of local variables I only introduced regex, obtaining an improved script for *create_arpfile.sh* and *computediffpop.sh*.

**Commands**

*improved_create_arpfile.sh*

```bash
#!/bin/bash

#Declaring parameter
locus=$1

#Extracting the information, using regex:
##for one or more space (\s+) change it for a tab, gobally (g)
cat table.data |sed -E 's/\s+/\t/g'| cut -f 1,$locus | grep -v "–" > significant_alleles_locus_1.data 

#Establishing a variable with the name of the allele
name=$(cat table.data | sed -E 's/\s+/\t/g' | cut -f $locus | grep -v – | head -n 1)

#Creating the sample
touch new_sample
echo "SampleName='Huelva-Spain'" > new_sample
echo "SampleSize=114" >> new_sample 
echo "SampleData={" >> new_sample
cat significant_alleles_locus_1.data | tail -n 7 >> new_sample
echo "}" >> new_sample

#Declaring the variables with the number of samples before and after
##before
n_samples=$(grep NbSamples dataset_${name}.arp | cut -d '=' -f 2)
##after
n_samplestotal=$((n_samples + 1))

#Obtaining the file "locus_${name}.arp" ----with sed----
## modifying the number of samples with the previously declared var.
cat dataset_${name}.arp new_sample | sed "s/NbSamples=${n_samples}/NbSamples=${n_samplestotal}/" > locus_${name}.arp

#using arlecore
arlecore locus_${name}.arp FstSettings.ars

#removing tmp files
rm significant_alleles_locus_1.data

#running the next bash script and passing the variable name as parameter 
./extract_matrices.sh $name
```

*improved_computediffpop.sh*

```bash
#!/bin/bash

#Declaring argument
name=$1

#Run serialise and change the name
./serialise_arp_tables.sh locus_${name}

mv pop_dist.data dist.1
mv pop_sign.data sign.1

#Getting significant significance
cat sign.1 | grep -v - > sign.2

#Sorting
cat sign.2 | sort -k 1,1 > sign.2.s
cat dist.1 | sort -k 1,1 > dist.1.s

#Joining
join sign.2.s dist.1.s > tmp
cat tmp | sed -E 's/\s+/\t/g' > difpop_${name}.txt

#Removing tmp files
rm sign.2.s dist.1.s tmp dist.1 sign.1 sign.2
```

# Day 4

## Exercise 11

Now, we went into the use of scripts written in other language such as AWK or R.
In exercise 11 we had to use an R script to produce an MultiDimensionality Scaling analysis on *.dist* and *.lab* files. 

First, we had to put the *.lab* file as header of the *.dist* file using the command **paste**. 

**Commands**

```bash
#!/bin/bash

#The lab file contains the name of the population as rows with it respective index.
##First I cut the index using the *complement* option of *cut*, hence the column that matches is excluded.
##Then, I squeezed and substituted the spaces for an underscore to have the same format in all the labels.
cat locus_CSF1PO.lab | cut --complement -f 1 | tr -s ' ' '_'  > lab_tmp

#I used *paste -s* to merge lines serially, thus I had the labels in only one line.
paste -s lab_tmp > lab_tmp_2

#Modifying dist matrix by switching from one or more spaces *\s+* to tab *\t*
cat locus_CSF1PO.dist | sed -E 's/\s+/\t/g' > dist_tmp

#Opening both tmp files and saving then into a new file to have labels on top of the matrix.
cat lab_tmp_2 dist_tmp > locus_CSF1PO_raw

#Performing last modification by substituting negative zeros, *-0.0* for *0.0*.
cat locus_CSF1PO_raw | sed -E 's/-0.0+/0.0/g' > locus_CSF1PO.mat

#Removing tmp files.
rm lab_tmp lab_tmp_2 dist_tmp locus_CSF1PO_raw

#Running R script
Rscript make_MDS.R 
```

## Exercise 12

For exercise 12 we had to automtise the MDS analysis for all loci.

**Commands**

```bash
#!/bin/bash

#Obtaining list of locus names in the directory 
##Regex was used to create a group (within parenthesis) everything is ignored except the group at '\1'. Credits to Prof Nunes.

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
```

## Exercise 13

For exercise 13 we were told to use an awk script to append a population structure to the *.arp* file containing all population for the locus CSF1PO. To this aim, we had to first obtain a structure using the awk script and then create a new file containing the initial *.arp* file and the structure at the end.

```bash
#Obtainin the structure file
awk -f MakeStructure.awk locus_CSF1PO.arp > str_tmp

#Merging the original .arp file followed by the structure
cat locus_CSF1PO.arp str_tmp > locus_CSF1PO_struct.arp

#Running arlecore with the amova arguments
arlecore locus_CSF1PO_struct.arp AmovaSettings.ars

#Removing tmp file
rm str_tmp
```
# Day 5

For the last two exercises, 14 and 15, we had to work with the computer cluster of the department. 

A computer cluster is a set of CPUs that run together, parallelizing the work that users submit. The cluster is arrange into partitions where we had to use the CSBR node which was set up specifically for us. The CSBR node is the entry point to the cluster and from there, the software running the cluster will decide in which CPU(s) our work will be done.

## Exercise 14

For exercise 14 we had to launch the computation of AMOVA for one locus in the cluster. The process consist on creating a WD for that locus, copy the necessary files to that WD and then launch AMOVA.

**Commands**

To connect to the server:

```bash 
# -p to specify the port to connect to on the remote host
ssh -p 91 peralta@biant-lsrv05.unige.ch
```

Once in the server I created a folder for the exercise:

```bash
mkdir ex_14_cluster
```

Then I copy files that I need from my PC to the cluster:

```bash
# -p to specify the port to connect to on the remote host
scp -P 91 ex_14/* peralta@biant-lsrv05.unige.ch:ex_14_cluster/.
```

Once in the cluster folder I run the script using:

```bash
sbatch -p csbr launch_amova.sh
```

*launch_amova.sh*

```bash
#!/bin/bash

#Stablishing the starting directory
startdir=$PWD

#Extracting the date for WD
datecompressed=$(date | sed -e 's/ //g' -e 's/://g')

#Creating a personal, tmp WD
workingdir=/tmp/${USER}_${datecompressed}
mkdir $workingdir

#Copying data needed to the tmp WD
cp AmovaSettings.ars ${workingdir}/AmovaSettings.ars

#Running awk, obtaining the structure file directly in the WD
awk -f MakeStructure.awk locus_CSF1PO.arp > str_tmp
cat locus_CSF1PO.arp str_tmp > ${workingdir}/locus_CSF1PO_struct.arp

#Running arlecore
cd $workingdir
arlecore locus_CSF1PO_struct.arp AmovaSettings.ars

#Extracting the xml file to the starting WD
cp locus_CSF1PO_struct.res/locus_CSF1PO_struct.xml ${startdir}/locus_CSF1PO_struct.xml

#Removing files
rm *.out
```

Lastly, to extract the *.xml* file, PWD=ex_14:

```bash
scp -P 91 peralta@biant-lsrv05.unige.ch:ex_14_cluster/*.xml $PWD/.
```

## Exercise 15

For exercise 15 we had to launch AMOVA in parallel for every locus on the cluster.

In this case the script looks like this

```bash
#!/bin/bash

#Stablishing starting WD
startdir=$PWD

#Extracting the date for directory
datecompressed=$(date | sed -e 's/ //g' -e 's/://g')

#Creating a personal, tmp WD for each of the locus in the starting directory
##I'm trying to use an array containing all the name to iterate with a 
##for loop, so I don't need to create tmps files
locus=($(ls *.arp | sed -e 's/locus_//' -e 's/.arp//'))

#I learned that to iterate an arry it is neccessary to access to all elements it contains.
##To access to all the elements, one has to proceed as follow: ${array[@ or *]}
for l in ${locus[@]}; do

	workingdir=/tmp/${USER}_${datecompressed}_${l}
	mkdir $workingdir
	
	#Copying data need to the tmp WD
	cp AmovaSettings.ars ${workingdir}/AmovaSettings.ars
	
	#Running awk, obtaining the structure file directly in the WD
	awk -f MakeStructure.awk locus_${l}.arp > str_tmp
	cat locus_${l}.arp str_tmp > ${workingdir}/locus_${l}_struct.arp

	#Switching to wd and running arlecore
	cd $workingdir
	arlecore locus_${l}_struct.arp AmovaSettings.ars

	#Extracting the xml file to the starting WD
	cp locus_${l}_struct.res/locus_${l}_struct.xml ${startdir}/locus_${l}_struct.xml

	#Removing tmp files
	rm *_tmp
done
```

To finish with the exercise, from my laptop I run the following command to retrieve all *.xml* files to my current WD, in this case ex_15.

```bash
scp -P 91 peralta@biant-lsrv05.unige.ch:ex_15_cluster/*.xml $PWD/.
```