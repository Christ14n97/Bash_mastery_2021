#!/bin/bash

#--- run serialise and change the name
./serialise_arp_tables.sh locus_D18S51

mv pop_dist.data dist.1
mv pop_sign.data sign.1

#getting significant significance
cat sign.1 | grep -v - > sign.2

#sorting
cat sign.2 | sort -k 1,1 > sign.2.s
cat dist.1 | sort -k 1,1 > dist.1.s

#joining
join sign.2.s dist.1.s > tmp
cat tmp | tr " ", \\t > difpop_D18S51.txt

#remove tmp files
rm sign.2.s dist.1.s tmp dist.1 sign.1 sign.2
