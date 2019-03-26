# simFunctions.R

# Deifine intial conditions
initSim <- function(pars, initId = 5, type = 'DFE'){
  with(as.list(pars),{
    switch(type,
           DFE = {
             tmp <- c(time = 0,
                      S_d = pop0_d-initId,
                      I_d = initId,
                      R_d = 0,
                      S_r = pop0_r,
                      I_r = 0,
                      R_r = 0,
                      cum_I_r = 0
             )},
           error('Initial conditions type not implemented.')
    )
    return(tmp)
  })
}

simEulerstep <- function (x, params, dt){
  with(c(as.list(x),params),{
    N_d <- S_d + I_d + R_d
    N_r <- S_r + I_r + R_r
    beta_dd <- cont_dd * trans_dd 
    beta_dr <- cont_dr * trans_dr 
    beta_rr <- cont_rr * trans_rr 
    dFOI <- beta_dd * I_d
    sFOI <- beta_dr * I_d
    rFOI <- beta_rr * I_r
    
    births_d <- rpois(n=1,lambda=birth_d*N_d*dt)
    births_r <- rpois(n=1,lambda=birth_r*N_r*dt)
    S_d.removal <- reulermultinom(n=1,size=S_d,rate=c(mort_d,dFOI,vax_d),dt=dt)
    I_d.removal <- reulermultinom(n=1,size=I_d,rate=c(mort_d,1/dur_d),dt=dt)
    R_d.removal <- reulermultinom(n=1,size=R_d,rate=c(mort_d),dt=dt)
    S_r.removal <- reulermultinom(n=1,size=S_r,rate=c(mort_r,sFOI,rFOI,vax_r),dt=dt)
    I_r.removal <- reulermultinom(n=1,size=I_r,rate=c(mort_r,1/dur_r),dt=dt)
    R_r.removal <- reulermultinom(n=1,size=R_r,rate=c(mort_r),dt=dt)
    
    # vector of changes
    c(
      dt, # change in time
      births_d-sum(S_d.removal), # change in S_d
      S_d.removal[2]-sum(I_d.removal), # change in I_d
      I_d.removal[2]-R_d.removal, # change in R_d
      births_r-sum(S_r.removal), # change in S_r
      S_r.removal[2]+S_r.removal[3]-sum(I_r.removal), # change in I_r
      I_r.removal[2]-R_r.removal, # change in R_r
      S_r.removal[2] # change in cum_I_r
    )
  })
}

runSim <- function(init, pars, maxtime = round(YEARS*365.25), dt = TIMESTEP, browse = F){
  ts <- NULL
  pop <- init
  if(browse) browser()
  for(tt in seq(0,maxtime,dt)){
    ts <- rbind(ts,pop)
    pop <- pop + simEulerstep(pop,pars,dt)
  }
  return(data.frame(ts))
}