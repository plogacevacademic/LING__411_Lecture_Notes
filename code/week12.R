library(rethinking)
data("rugged")


head(rugged)


d <- rugged
# make log version of outcome 
d$log_gdp <- log( d$rgdppc_2000 )
# extract countries with GDP data 
dd <- d[ complete.cases(d$rgdppc_2000) , ]

# check how much data we have excluded
nrow(d)
nrow(dd)

# split countries into Africa and not-Africa 
d.A1 <- dd[ dd$cont_africa==1 , ] # Africa 
d.A0 <- dd[ dd$cont_africa==0 , ] # not Africa

m7.5b <- map( alist(
  log_gdp ~ dnorm( mu , sigma ) , 
  mu <- a + bR*rugged + bAR*rugged*cont_africa + bA*cont_africa, 
  a~dnorm(8,100), 
  bA~dnorm(0,1), 
  bR~dnorm(0,1), 
  bAR~dnorm(0,1), 
  sigma ~ dunif( 0 , 10 )
) , data=dd )

precis(m7.5b)



m7.5b_stan <- map2stan( alist(
  log_gdp ~ dnorm( mu , sigma ) , 
  mu <- a + bR*rugged + bAR*rugged*cont_africa + bA*cont_africa, 
  a~dnorm(8,100), 
  bA~dnorm(0,1), 
  bR~dnorm(0,1), 
  bAR~dnorm(0,1), 
  sigma ~ dunif( 0 , 10 )
) , data=dd, warmup = 100, verbose = T, rng_seed = 123 )

cat( m7.5b_stan@model )

summary(m7.5b_stan)
precis(m7.5b_stan)

samples <- extract.samples(m7.5b_stan)

mean(samples$bA < 0)


m7.5b_stan_B <- map2stan( alist(
  log_gdp ~ dnorm( mu , sigma ) , 
  mu <- a + bR*rugged + bAR*rugged*cont_africa + bA*cont_africa, 
  a~dnorm(8,100), 
  bA~dnorm(0,1), 
  bR~dnorm(0,1), 
  bAR~dnorm(0,1), 
  sigma ~ dexp(1)
) , data=dd, warmup = 100, verbose = T, rng_seed = 123 )


precis(m7.5b_stan)
precis(m7.5b_stan_B)

summary(m7.5b_stan)
summary(m7.5b_stan_B)


mean(samples$bAR < 0)

mean(samples$bR < 0)

hist(samples$bR)

str(samples)

dim(samples)




#### VOT dataset
library(tidyverse)

(load("../data/VOT/english.rda"))

head(df)

unique(df$TargetConsonant)

df$voiced <- ifelse(df$TargetConsonant %in% c("d", "g"), "voiced", "voiceless")
df$cVoiced <- ifelse(df$voiced == "voiced", 1, -1) * 0.5


df %>% group_by(gender, voiced) %>% summarize( mean_msVOT = mean(msVOT) ) %>% 
      ggplot(aes(gender, mean_msVOT, color = voiced, group = voiced)) + geom_point() + geom_line()


# intercept-only model
VOT_model1 <- map2stan( alist(
  msVOT ~ dnorm(mu, sigma),
  mu <- a,
  a ~ dnorm(0, 1000),
  sigma ~ dunif(0, 200)
), data = as.data.frame(df) )

precis(VOT_model1)

# Let's find out if Ugurcan is right.

# Gaussian: density function
plot(function(x) dnorm(x, 0, 50), xlim = c(-150,150))
# Gaussian: cumulative distribution function
plot(function(x) pnorm(x, 0, 50), xlim = c(-150,150))

# probability mass to the left of -50 for
# a Gaussian with mu=0, sigma=50
pnorm(-50, 0, 50)
1-pnorm(50, 0, 50)
# conclusion: in a Gaussian, the probability mass
# between [mean-sd; mean+sd] is 68%


# intercept, plus slope for voicing model
VOT_model2 <- map2stan( alist(
  msVOT ~ dnorm(mu, sigma),
  mu <- a + b*cVoiced,
  a ~ dnorm(0, 1000),
  b ~ dnorm(0, 100),
  sigma ~ dunif(0, 200)
), data = as.data.frame(df) )

plot(VOT_model2)
precis(VOT_model2)

samples2 <- extract.samples(VOT_model2)
ggplot(as.data.frame(samples2), aes(b)) + geom_histogram()

mean(samples2$b >= 0)

df$cFemale <- ifelse(df$gender == "m", -0.5, 0.5)

# intercept, plus slope for voicing, and slope for gender model
# strongly informative prior for gender
VOT_model3 <- map2stan( alist(
  msVOT ~ dnorm(mu, sigma),
  mu <- a + b*cVoiced + c*cFemale,
  a ~ dnorm(0, 1000),
  b ~ dnorm(0, 100),
  c ~ dnorm(0, 1),
  sigma ~ dunif(0, 200)
), data = as.data.frame(df) )

# intercept, plus slope for voicing, and slope for gender model
# less informative prior for gender
VOT_model3B <- map2stan( alist(
  msVOT ~ dnorm(mu, sigma),
  mu <- a + b*cVoiced + c*cFemale,
  a ~ dnorm(0, 1000),
  b ~ dnorm(0, 100),
  c ~ dnorm(0, 100),
  sigma ~ dunif(0, 200)
), data = as.data.frame(df) )

# intercept, plus slope for voicing, and slope for gender model
# less informative prior for gender
VOT_model3C <- map2stan( alist(
  msVOT ~ dnorm(mu, sigma),
  mu <- a + b*cVoiced + c*cFemale,
  a ~ dnorm(0, 1000),
  b ~ dnorm(0, 100),
  c ~ dnorm(0, 10),
  sigma ~ dunif(0, 200)
), data = as.data.frame(df) )
precis(VOT_model3)
precis(VOT_model3B)

samples3 <- extract.samples(VOT_model3)
samples3B <- extract.samples(VOT_model3B)
samples3C <- extract.samples(VOT_model3C)

mean(samples3$c > 0) # prior for c standard deviation: 1
mean(samples3B$c > 0) # prior for c standard deviation: 100
mean(samples3C$c > 0) # prior for c standard deviation: 10
