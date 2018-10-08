<<<<<<< HEAD

# load the required packages (install them if you don't have them already)
library(languageR)
library(tidyverse)
library(ggplot2)


# create a vector named x by assigning it all numbers between 1 and 25
x <- 1:25

# compute the average of this vector
mean(x)

# determine how many elements the vector has
length(x)

# convert this integer vector to a character vector
as.character(x)

# load the 'warlpiri' data.frame from the package 'languageR'
library(languageR)
data(warlpiri)

# display the first 3 lines of the data.frame
head(warlpiri, 3)

# look up the meaning of the various columns in the data.frame
?warlpiri

# find out how many rows are in the data.frame
nrow(warlpiri)

# find out which values can occur in the column which indicates the presence of ergative case marking
as.data.frame(warlpiri$CaseMarking)

# determine the overall frequency of ergative case marking in the data set
attach(warlpiri)
table(CaseMarking, WordOrder)
detach(warlpiri)
sum(warlpiri$CaseMarking == 'ergative')
summary(warlpiri$CaseMarking)


with(warlpiri, {
  table(CaseMarking, WordOrder)
})

## In *separate commands*, determine the frequency of ergative case marking as a function of the variables listed
## below, and please save the results in the specified data frames. Inspect the data frames with View() to make
## sure that the results makes sense.
# ... (i) word order (save in data frame called 'proportions_by_WO')
proportions_by_WO <- warlpiri %>% group_by(WordOrder) %>% 
                                  dplyr::summarize(prop_erg = mean(CaseMarking == 'ergative'),
                                                   N = length(CaseMarking))
proportions_by_WO

# ... (ii) overtness of object  (save in data frame called 'proportions_by_ovObject')
proportions_by_ovObject <- warlpiri %>% group_by(OvertnessOfObject) %>% 
                                        dplyr::summarize(prop_erg = mean(CaseMarking == 'ergative'),
                                                   N = length(CaseMarking))
proportions_by_ovObject

# ... (iii) animacy of the object (save in data frame called 'proportions_by_animObj')
proportions_by_animObj <- warlpiri %>% group_by(AnimacyOfObject) %>% 
                                        dplyr::summarize(prop_erg = mean(CaseMarking == 'ergative'),
                                                         N = length(CaseMarking))
proportions_by_animObj

# create plots in ggplot2 (with lines or bars)  from each of the data.frames from the previous step

proportions_by_WO %>% ggplot(aes(WordOrder, prop_erg, group = 1)) + 
                        geom_point() + geom_line()


x <- data.frame(a = 1:4, b = 1:4, g = c('a','b','a','b'))
x

ggplot(x, aes(a, b, group = g, color=g))+geom_point()+geom_line()

## Respond with a a comment below:
## Does there seem to be a relation between ergative case marking and ...
## ... word order

## ... overtness of the object

## ... animacy of the object
=======

# load the required packages (install them if you don't have them already)
library(languageR)
library(tidyverse)
library(ggplot2)


# create a vector named x by assigning it all numbers between 1 and 25

# compute the average of this vector

# determine how many elements the vector has

# convert this integer vector to a character vector


# load the 'warlpiri' data.frame from the package 'languageR'

# display the first 3 lines of the data.frame

# look up the meaning of the various columns in the data.frame

# find out how many rows are in the data.frame

# find out which values can occur in the column which indicates the presence of ergative case marking

# determine the overall frequency of ergative case marking in the data set

## In *separate commands*, determine the frequency of ergative case marking as a function of the variables listed
## below, and please save the results in the specified data frames. Inspect the data frames with View() to make
## sure that the results makes sense.
# ... (i) word order (save in data frame called 'proportions_by_WO')
# ... (ii) overtness of object  (save in data frame called 'proportions_by_ovObject')
# ... (iii) animacy of the object (save in data frame called 'proportions_by_animObj')

# create plots in ggplot2 (with lines or bars)  from each of the data.frames from the previous step


## Respond with a a comment below:
## Does there seem to be a relation between ergative case marking and ...
## ... word order

## ... overtness of the object

## ... animacy of the object
>>>>>>> 4b3a48f1d258405da7584befb390731a37ae10bc
