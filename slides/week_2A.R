# First, let's install three things to download your data. (If you are on Windows.)
# 1. Notepad++
# 2. Git for Windows
# 3. TortoiseGit

# Today's datasets:
# - Alice
# - Bob
# - Maybe: Bob's German dataset

# load package called 'languageR' 
library(languageR)

data("dative") # import data called 'dative' into the workspace

# get an idea of the data
head(dative)
View(dative)

# look at the structure of the data.frame
str(dative)


## Of what type do the variables seem to be?
## 1) Categorical or continuous?
## 2) On what scale were they measured? (Interval, ratio, ordinal?)



# convert 'verb' to a character vector
dative$Verb <- as.character(dative$Verb)

dative$RealizationOfRecipient
levels(dative$RealizationOfRecipient)

unique(dative$LengthOfRecipient)

sort(unique(dative$LengthOfRecipient))

library(magrittr)
unique(dative$LengthOfRecipient) %>% sort()

table(dative$LengthOfRecipient)

# diff. ways of looking at the realization of the recepient distribution 
res <- table(dative$RealizationOfRecipient) # #1
res/sum(res)


## To understand the dataset better, let's look at 
## - measures of central tendency (mean/average, median, mode)
## - measures of dispersion (standard deviation, IRQ, range)
## - Histograms and quantiles
## - Box plots
## - Mosaic plots

