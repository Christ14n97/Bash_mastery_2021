#Mathias Currat and Jose Manuel Nunes - Computer skills for biological research 2021
#script for exo13 of day 4

BEGIN {

	numberofpopulationsAfrica=0
	numberofpopulationsEurope=0

	print "[[structure]]"
	print
	print "StructureName = \"Two groups of populations, one with Africans and one with Europeans\""
	print "NbGroups = 2"
}

{
	#if the line contains the pattern "SampleName"
	if ( $0 ~ /SampleName=/ ) {
		
		#if the line contains an African sample
		if ( $0 ~ /Algeria|Algerian|Egypt|Egyptian|Morocco|Moroccan/  ) {
			#increase the number of population from Africa
			numberofpopulationsAfrica++
			#remove the substring "SampleName" from the input line	
			sub(/SampleName=/,"",$0)
			sub(/\t/,"",$0)
			#add the population name (remaining line) to an array
			populationsAfrica[numberofpopulationsAfrica]=$0
		} else {
			#increase the number of population from Europe
			numberofpopulationsEurope++
			#remove the substring "SampleName" from the input line	
			sub(/SampleName=/,"",$0)
			sub(/\t/,"",$0)
			#add the population name (remaining line) to an array
			populationsEurope[numberofpopulationsEurope]=$0
		}
	}
}

END {
	print "Group = {"
	for (i in populationsAfrica) {
		print populationsAfrica[i];
	}
	print "}"
	print "Group = {"
	for (i in populationsEurope) {
		print populationsEurope[i];
	}	
	print "}"	
}