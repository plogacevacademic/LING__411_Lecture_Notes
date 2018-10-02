# First, let's install three things to download your data. (If you are on Windows.)
# 1. Notepad++
# 2. Git for Windows
# 3. TortoiseGit

# Today's datasets:
# - Alice
# - Bob
# - Maybe: Bob's German dataset

install.packages("languageR")

# load package called 'languageR' 
library(languageR)

data("dative") # import data called 'dative' into the workspace

# get an idea of the data
head(dative)
View(dative)

# look at the structure of the data.frame
str(dative)

# convert 'verb' to a character vector
dative$Verb <- as.character(dative$Verb)

# let's look at a column 
dative$RealizationOfRecipient
levels(dative$RealizationOfRecipient)

## What is going on with length of recipient and theme?
unique(dative$LengthOfRecipient)
sort(unique(dative$LengthOfRecipient))
## equivalent to: unique(dative$LengthOfRecipient) %>% sort()

unique(dative$LengthOfTheme)
sort(unique(dative$LengthOfTheme))

# plot histograms of lengths
library(ggplot2)
library(magrittr)
dative %>% ggplot(aes(LengthOfRecipient)) + geom_histogram()
dative %>% ggplot(aes(LengthOfTheme)) + geom_histogram()

head(dative)

# take a column subset of the dative data frame
dative_lengths <- dative %>% dplyr::select(LengthOfRecipient, LengthOfTheme)
head(dative_lengths)


# plot length of recipient by length of theme
ggplot(dative_lengths, aes(LengthOfRecipient, LengthOfTheme)) + geom_point()
# ... make the points semi-transparent
ggplot(dative_lengths, aes(LengthOfRecipient, LengthOfTheme)) + geom_point(alpha=0.05)
# ... jitter the point
ggplot(dative_lengths, aes(LengthOfRecipient, LengthOfTheme)) + geom_jitter()


## create side-by-side histograms of length
# reshape to wide format
dative_lengths_long <- dative_lengths %>% tidyr::gather(key, value, LengthOfRecipient, LengthOfTheme)
head(dative_lengths_long)

# plot side-by-side histograms
ggplot(dative_lengths_long, aes(value))
ggplot(dative_lengths_long, aes(value)) + geom_histogram() + facet_wrap(~key)

ggplot(dative_lengths_long, aes(value)) + stat_bin(aes(value, ..count..))+ facet_wrap(~key)
ggplot(dative_lengths_long, aes(value)) + stat_bin(aes(value, ..density..), color = "blue", fill = "blue") + 
  facet_wrap(~key) + theme_bw()

ggplot(dative_lengths_long, aes(key, value)) + geom_boxplot()

ggplot(dative_lengths_long, aes(key, value)) + geom_violin()


## 
dative_relevant <- dative %>% dplyr::select(LengthOfRecipient, LengthOfTheme, RealizationOfRecipient)
head(dative_relevant)

library(dplyr)

dative_byLenRec <- dative_relevant %>% group_by(LengthOfRecipient) %>% 
                                        dplyr::summarize( perc_NP = mean(RealizationOfRecipient == "NP") ) 
dative_byLenRec

library(MASS)
library(Hmisc)
dative_relevant$LengthOfRecipientCat <- Hmisc::cut2(dative_relevant$LengthOfRecipient, g = 2)
summary(dative_relevant$LengthOfRecipientCat)

dative_byLenRec2 <- dative_relevant %>% group_by(LengthOfRecipientCat) %>% 
                                        dplyr::summarize( perc_NP = mean(RealizationOfRecipient == "NP") ) 
dative_byLenRec2

dative_byLenRec2 %>% ggplot(aes(LengthOfRecipientCat, perc_NP, group = 1)) + geom_point() + geom_line()


dative_relevant$LengthOfThemeCat <- Hmisc::cut2(dative_relevant$LengthOfTheme, g = 2)

dative_byLengths <- dative_relevant %>% group_by(LengthOfRecipientCat, LengthOfThemeCat) %>% 
                                        dplyr::summarize( perc_NP = mean(RealizationOfRecipient == "NP") ) 
dative_byLengths

dative_byLengths %>% ggplot(aes(LengthOfRecipientCat, perc_NP, group = LengthOfThemeCat, 
                                color = LengthOfThemeCat)) + geom_point() + geom_line()



