install.packages("dplyr")
library(dplyr)

#check working directory
getwd()

#changing it
#setwd("D:/OneDrive/Documents/data_science_project")
#getwd()

#load the dataset
data<-read.csv(file.choose(),header=T)
data

#viewing first few entries of the dataframe
head(data)

#size of the dataset
dim(data)

#name of the columns of data
names(data)

#DATA PRE PRCOESSING STARTS HERE

#CHECK FOR DUPLICATE VALUES
table(colnames(data))

#changes the data into data frame
new_data=as.data.frame.matrix(data)
new_data
dim(new_data)

#as there are no duplicate columns, hence we will now move to check null values
lapply(new_data,function(x) { length(which(is.na(x)))})

#handling null values
#HANDLING null values

data$Complaint.ID[is.na(data$Complaint.ID)]<-mean(data$Complaint.ID,na.rm=TRUE) #REPLACING WITH MEAN
data$Complaint.ID
sum(is.na(data$Complaint.ID))

data$ZIP.code[is.na(data$ZIP.code)]<- '76200' #REPLACING WITH value
data$ZIP.code
sum(is.na(data$ZIP.code))

#PERFORMING encoding
data$Timely.response. = factor(data$Timely.response., 
                               levels = c('Yes','No'), 
                               labels = c(1, 0 ))
data$Timely.response.

data$Consumer.disputed.= factor(data$Consumer.disputed., 
                                levels = c('Yes','No' ,'N/A'), 
                                labels = c(1, 0 ,2))
data$Consumer.disputed.

#adding a new column for indexing
no=nrow(data)
order=seq(1,no)
final_file <- cbind(order,data)
final_file
dim(final_file)
colnames(final_file)

#diving the whole dataset into different
Data1<-final_file[,1:6]
Data1
colnames(Data1)
dim(Data1)

Data_2<-final_file[,7:11]
#as we have to join these columns, hence we must have one column common in them,
#hence we have to add complaint id in this also
Data2<-cbind(final_file$Complaint.ID,Data_2)
colnames(Data2)
colnames(Data2)[1]<-"Complaint.ID"
colnames(Data2)
dim(Data2)

#same with 3
Data_3<-final_file[,12:18]
#as we have to join these columns, hence we must have one column common in them,
#hence we have to add complaint id in this also
Data3<-cbind(final_file$Complaint.ID,Data_3)
colnames(Data3)
colnames(Data3)[1]<-"Complaint.ID"
colnames(Data3)
dim(Data3)


#now performing data cleaning on individual tables
lapply(Data1,function(x) { length(which(is.na(x)))})
lapply(Data2,function(x) { length(which(is.na(x)))})
lapply(Data3,function(x) { length(which(is.na(x)))})

#as there are no null values, hence we will continue further

#as for plotting the graphs in the tableau we need the joined data in one file only,
# but containing multiple tables, hence we will join the data to get one file 

#first we will perform outer join between data1 and data2 because Outer Join in  R 
#combines the results of both left and right outer joins. The joined table will contain
#all records from both the tables

# outer join in R using outer_join() function 
library(dplyr)
Data1= Data1 %>% full_join(Data2,by="Complaint.ID")
Data1
dim(Data1)

#as we know that data1 already contains whole data, hence now we will have to take the values from data3 and add
#it to data1 to get full dataset
library(dplyr)

Data1= Data1 %>% right_join(Data3,by="Complaint.ID")
Data1
dim(Data1)