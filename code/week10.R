
library(languageR)
data(dative)


View(dative)

summary(dative)


library(tidyverse)
library(magrittr)
library(ggplot2)

dative$is_NP <- dative$RealizationOfRecipient == "NP"

# summarize
dative_by_pron <- 
dative %>% group_by(PronomOfRec) %>% summarize(prop_NP = mean(is_NP), N = n())

# plot
dative_by_pron %>% ggplot(aes(PronomOfRec, prop_NP)) + 
  geom_bar(stat = "identity")

## posterior distribution of the proportion of NP realizations of 
## nonpronominal recipients

# set up grid
cur_df <- filter(dative_by_pron, PronomOfRec == "pronominal")
n = 10000
p_grid <- seq(0, 1, length.out = n)
prior <- rep_len(1/n, length.out = n)
lik <- with(cur_df, dbinom(x = prop_NP*N, size = N, prob = p_grid))
unst_posterior <- lik * prior
posterior <- unst_posterior / sum(unst_posterior)

plot(p_grid, posterior, xlim=c(.8, 1), type = "l")

# sample from posterior
posterior_samples <- sample(p_grid, posterior, size = 10^8, replace = TRUE)

# compute HPDI
library(rethinking)
HPDI(posterior_samples, prob = .99)


install.packages("devtools")
library(devtools)
devtools::install_github("rmcelreath/rethinking")


library(rethinking)

# model for a single row
model_spec <- alist(
  # likelihood
  (prop_NP*N) ~ dbinom(size = N, prob = z),
  # prior
  z ~ dunif(0, 1)
)

data <- dative_by_pron %>% filter(PronomOfRec == "pronominal") %>% as.data.frame()
model <- rethinking::map( model_spec, data =  data)
precis(model)


# create a 'downsampled' dataset 
dative_by_pron_downsampled <- dative_by_pron %>% mutate( N = round(N/100))


# linear model for the downsampled dataset
model_spec2 <- alist(
  # likelihood
  k ~ dbinom(size = N, prob = z),
  # linear model
  z <- intercept + slope * cRecpro,
  # prior
  intercept ~ dunif(0, 1),
  slope ~ dunif(-1, 1)
)

data <- dative_by_pron_downsampled %>% as.data.frame()
data$cRecpro <- with(data, ifelse(PronomOfRec == "nonpronominal", 0, 1))
data$k <- with(data, round(prop_NP*N))
data

model <- rethinking::map( model_spec2, data = data, start = list(intercept = .5, slope = 0))
precis(model)


# linear model for the original dataset

data <- dative_by_pron %>% as.data.frame()
data$cRecpro <- with(data, ifelse(PronomOfRec == "nonpronominal", 0, 1))
data$k <- with(data, round(prop_NP*N))
data

model <- rethinking::map( model_spec2, data = data, start = list(intercept = .5, slope = 0))
precis(model)

