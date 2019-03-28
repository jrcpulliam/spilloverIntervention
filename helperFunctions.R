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
             beta_dd <- cont_dd * trans_dd
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

# Define parameter adjustments for interventions
intvPars <- function(prop,pars,intv = 'none'){
  switch(as.character(intv),
         none = {},
         fertCont_d = {
           pars['birth_d'] <- pars['birth_d']*prop # decrease birth rate
         },
         cull_d = {
           le <- (1/pars['mort_d'])*prop # decrease life expectancy
           pars['mort_d'] <- 1/le
         },
         reduceContact_d = {
           pars['cont_dd'] <- pars['cont_dd']*prop # Behavior manipulation of donor
         },
         reduceContact_r = {
           pars['cont_rr'] <- pars['cont_rr']*prop # behavior modification of recipient
         },
         biosecurity = {
           pars['cont_dr'] <- pars['cont_dr']*prop # biosecurity measures at the interface
         },
         vax_d = {
           pars['vax_d'] <- (1-prop) # instead of affecting infection probs...
         },
         vax_r = {
           pars['vax_r'] <- (1-prop) # instead of affecting infection probs...
         },
         tx_d = {           
           infDurTx <- pars['dur_d']*prop # decrease duration of infection
           pars['dur_d'] <- infDurTx 
         },
         tx_r = {
           infDurTx <- pars['dur_r']*prop # decrease duration of infection
           pars['dur_r'] <- infDurTx 
         },
         error('Intervention unknown.'))
  return(pars)
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