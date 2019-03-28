# simFunctions.R

# Deifine intial conditions
initSim <- function(pars, type = 'DFE', initId = 5){
  with(as.list(pars),{
    switch(as.character(type),
           DFE = {
             tmp <- c(time = 0,
                      S_d = pop0_d-initId,
                      I_d = initId,
                      R_d = 0,
                      S_r = pop0_r,
                      I_r = 0,
                      R_r = 0,
                      cum_I_r = 0,
                      cum_I_sp = 0
             )},
           EE = {
             gamma_d <- 1/dur_d
             S_eq <- (mort_d + gamma_d) / beta_dd
             I_eq <- (birth_d * pop0_d / S_eq - mort_d) / beta_dd
             R_eq <- gamma_d * I_eq / mort_d
             tmp <- c(time = 0,
                      S_d = S_eq,
                      I_d = I_eq,
                      R_d = R_eq,
                      S_r = pop0_r,
                      I_r = 0,
                      R_r = 0,
                      cum_I_r = 0,
                      cum_I_sp = 0
             )},
           error('Initial conditions type not implemented.')
    )
    return(round(tmp))
  })
}

# Convert (annual) probability to daily hazard rate
toRate <- function(pp,dt = 365.25){
  -log(1-pp)/dt
}

# Calculate transmission coefficients from R0 and other paramters
betaCalc <- function(R0,N0,delta,gamma){
  R0 * (delta + gamma) / N0
}

# Calculate results for comparsion from a set of simulations
output <- function(sim){
  cum_I_r <- max(sim$cum_I_r)
  cum_I_sp <- max(sim$cum_I_sp)
  return(c(cum_I_r = cum_I_r, cum_I_sp = cum_I_sp))
}

## Run nn replicates of an intervention scenario and give summary results
simSummary <- function(proportionChange, interventionType, baseline, nn = REPS, browse = F){
  switch(as.character(baseline),
         ex1 = {
           inits <- inits1
           pars <- ex1
         },
         ex2 = {
           inits <- inits2
           pars <- ex2
         },
         error('Baseline scenario unknown.'))
  if (browse) browser()
  sims <- replicate(nn,runSim(inits,intvPars(proportionChange,pars,interventionType)))
  out <- unname(t(sapply(1:nn,function(ii) output(sims[,ii]))) %>% apply(2,mean))
  return(data.frame(prop = proportionChange, intv = interventionType, baseline = baseline, cum_I_r = out[1], cum_I_sp = out[2]))
}