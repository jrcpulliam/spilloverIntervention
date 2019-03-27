# simFunctions.R

# Deifine intial conditions
initSim <- function(pars, type = 'DFE', initId = 5){
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
      S_r.removal[2]+S_r.removal[3], # change in cum_I_r (total infections in recipient)
      S_r.removal[2] # change in cum_I_sp (total spillover infections)
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

simPlot <- function(sim){
  tmp <- as.data.frame(sim) %>% select(-c(cum_I_r,cum_I_sp)) %>% gather(subpop,individuals,-time)
  plt <- (
    tmp %>% 
      ggplot(aes(x = time/7, y = individuals, col = subpop)) +
      geom_line(size = 1.2) +
      xlab("time (weeks)") +
      ylab("individuals") +
      coord_cartesian(clip = "off") +
      theme_dviz_hgrid(font_family = 'Arial') +
      theme(
        axis.ticks.x = element_blank(),
        axis.line = element_blank(),
        plot.margin = margin(3, 7, 3, 1.5),
        legend.title.align = 0.5,
        legend.justification = c(0.5,0)
      )
  )
  return(plt)
}

foiPlot <- function(sim, pars){
  tmp <- as.data.frame(sim) %>% mutate(sFOI = pars[['cont_dd']]*pars[['trans_dd']]*I_d)
  plt <- (
    tmp %>% 
      ggplot(aes(x = time/7, y = sFOI)) +
      geom_line(size = 1.2) +
      xlab("time (weeks)") +
      ylab("spillover FOI") +
      coord_cartesian(clip = "off") +
      theme_dviz_hgrid(font_family = 'Arial') +
      theme(
        axis.ticks.x = element_blank(),
        axis.line = element_blank(),
        plot.margin = margin(3, 7, 3, 1.5)
      )
  )
  return(plt)
}

output <- function(sim, pars){
  cum_I_r <- max(sim$cum_I_r)
  cum_I_sp <- max(sim$cum_I_sp)
  mean_I_d <- mean(sim$I_d)
  mean_sFOI <- pars[['cont_dd']]*pars[['trans_dd']]*mead_I_d
  return(c(cum_I_r = cum_I_r, cum_I_sp = cum_I_sp, mean_sFOI = mean_sFOI, mean_I_d = mean_I_d))
}