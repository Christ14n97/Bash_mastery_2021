#getting significant significance
cat sign.1 | grep -v - > sign.2

#sorting
cat sign.2 | sort -k 1,1 > sign.2.s
cat dist.1 | sort -k 1,1 > dist.1.s

#joining
join sign.2.s dist.1.s > difpop_D3S1358.txt

#remove tmp files
rm sign.2.s
rm dist.1.s

#Q1
cat difpop_D3S1358.txt | wc -l
63 populations

#Q2
cat difpop_D3S1358.txt | tr " ", \\t | sort -k 3 -n
21~4 and 21~19

#------

echo "this works"
