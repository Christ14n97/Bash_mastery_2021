#!/bin/bash

# Jose Manuel Nunes and Mathias Currat
# 2014.09.06
# Computer skills for biological research 2021 # Script for ex07 of day 2
#--------------------------

if (( $# != 1 )); then echo "Usage: $0 basename_locus"; exit; fi
basename=$1
if [[ ! -f ${basename}.dist || ! -f ${basename}.sign ]]; then echo "Missing .dist or .sign file"; exit; fi 
for tempfile in pop_pairs.data pop_vals.data pop_dist.data pop_sign.data; do if [[ -f $tempfile ]]; then mv $tempfile ${tempfile}.bkp; fi; done
file=${basename}.dist
lines=$(wc -l $file | cut -d ' ' -f 1) 
jointfile=$(cat ${basename}{.dist,.sign} | grep -c a) 
for ((i=1; i<=$lines; i++)); do for ((j=1; j<=i; j++)); do echo $i~$j; done; done > pop_pairs.data 
paste -s $file | tr -s '\t ' '\n' > pop_vals.data 
paste pop_pairs.data pop_vals.data > pop_dist.data 
file=${basename}.sign 
for ((i=2; i<=$lines; i++)); do for ((j=1; j<i; j++)); do echo $i~$j; done; done > pop_pairs.data 
tail -n +2 $file | for ((i=1; i<$lines; i++)); do read -a line; echo ${line[*]:0:$i}; done | tr '\t\n' ' ' | tr -s ' ' '\n' > pop_vals.data 
paste pop_pairs.data pop_vals.data > pop_sign.data 
echo $jointfile > /dev/null; unset jointfile 
rm pop_pairs.data pop_vals.data 
for tempfile in pop_{pairs,vals}.data.bkp; do if [[ -f $tempfile ]]; then mv $tempfile ${tempfile/.bkp}; fi; done
