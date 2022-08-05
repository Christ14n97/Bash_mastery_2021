
# read input into R data frame
reynolds_frame <- read.table(file="locus_D7S820.mat",fill=TRUE,header=TRUE)

# make distance matrix and change into R dist object 
reynolds_matrix <- as.matrix(reynolds_frame)
reynolds_dist <- as.dist(reynolds_matrix)

# define colors to identify regions
region_colors <- rep("green",times=nrow(reynolds_frame))
region_colors[grep("Spain",colnames(reynolds_frame))] <- "red"

# required R library for this MDS
require(vegan)

# run the MDS
D7S820_MDS <- metaMDS(reynolds_dist)

# open PNG device to output graphic in PNG format
png(file="D7S820_MDS_plot.png")

# create the plot
plot(D7S820_MDS,type="n",xlab="Axis 1", ylab="Axis 2", main="D7S820 across Gibraltar")

# add the points
points(D7S820_MDS,pch=19,col=region_colors)

# add a legend
legend("topright", legend=c("North of Gibraltar", "South of Gibraltar"), pch=19, col=c("red", "green"))

# close the PNG device
dev.off()
