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
) , data=dd )

summary(m7.5b_stan)
precis(m7.5b_stan)

samples <- extract.samples(m7.5b_stan)

mean(samples$bA < 0)






mean(samples$bAR < 0)

mean(samples$bR < 0)

hist(samples$bR)

str(samples)

dim(samples)
