
# load all required packages

# create a vector called 'p' with the values 0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9 (use seq())

# create a vector called 'q' from p, by multiplying it by 3 

# create a vector called 'r' from q, by adding 5 to it

# create a data.frame called df, with three columns which correspond to the vectors p, q, r (use data.frame())

# print the first three rows of df

## Run the line below to estimate the parameters of a linear model with r as dependent variable, and p as predictor.
## The last two lines of the output below show the estimated value of the intercept, and of the slope for p (when p is used as a predictor)  
lm (r ~ p, data = df)

# What do the intercept and slope estimates tell us about the relationship between r and p?

# Does the mathematical relationship between p and r have anything to do with how we created the vectors q and r? 

# What will happen to the estimates of the linear model above if we added 1 to all elements of vector r?



## Moving on ...

# load the 'dative' data.frame from the package 'languageR'

# determine the number of occurences of each verb in the dataset (use group_by() and summarize())

# which verb occurs 207 times? (use subset() or filter() on the previously created data frame)

## in several steps, determine which verb co-occurs with the longest theme argument
# step 1: using group_by()/summarize() and max(), create a data.frame called 'theme_max_themelen_by_verb' which contains 
#         the longest LengthOfTheme value for each verb. Call the column containing the maximum of LengthOfTheme max_LengthOfTheme.

# step 2: take a subset of theme_max_len_by_verb
subset(theme_max_themelen_by_verb, max_LengthOfTheme == max(max_LengthOfTheme))

## Bonus question: Why does the code a produce a different result than the code under the previous comment?
## Hint: It has to do with the difference between '=' and '=='.


# plot a histogram of maximum theme lengths by verb (use geom_histogram())

# plot another histogram of maximum theme lengths by verb, but this time with the parameter "binwidth = 10" to geom_histogram()

# let's plot the same again, but this time with the parameter "binwidth = 30" to geom_histogram()

# let's plot the same again, but this time with the parameter "binwidth = 1" to geom_histogram()

## Why do the four above histograms look so different?


# Repeat the above aggregation by Verb, but this time include the verb's semantic class in the grouping (use group_by(Verb, SemanticClass)).
# Save the result in 'theme_max_themelen_by_verb'

## Compare theme_max_themelen_by_verb and theme_max_themelen_by_verb2. How do they differ?

# create a boxplot of maximum theme lengths by the verb's semantic class (i.e., the semantic class goes on the x-axis, and the theme length
# on the y-axis). (use geom_boxplot()) 

## By looking at the above plot, please answer the following question:
# What can we say about the median of theme length in the semantic class 'p' compared to the other semantic classes?


# Please verify this statement by computing the medians of maximum theme length for every semantic class (use group_by(), summarize(), and median())

