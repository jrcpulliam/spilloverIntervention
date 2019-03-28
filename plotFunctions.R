# plotFunctions.R

# Plot all compartments for a single simulation run
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

# Plot the spillover FOI over time for a single simulation run
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
        plot.margin = margin(3, 7, 3, 1.5),
        legend.title.align = 0.5,
        legend.justification = c(0.5,0)
      )
  )
  return(plt)
}

# Summary plot for number of spillover cases in the recipient (by intervention)
resPlot_sp <- function(scenario, results = res){
  tmp <- results %>% 
    filter(baseline == scenario) %>% 
    mutate(intensity = as.character((1-prop)*100), intv = factor(intv, levels = tab2$Type, labels = tab2$Intervention))
  plt <- (
    tmp %>% 
      ggplot(aes(x = intv, y = intensity, fill = cum_I_sp)) +
      geom_tile(width = 0.95) +
      scale_fill_viridis_c(option = "B", begin = 0.98, end = 0.15,
                           name = "total spillover cases") +
      scale_y_discrete(name = 'intervention intensity') +
      scale_x_discrete(name = 'intervention type') +
      coord_fixed(expand = FALSE) +
      theme_dviz_open(font_family = 'Arial') +
      theme(axis.line = element_blank(),
            axis.ticks = element_blank(),
            axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
            axis.text.y = element_text(size = 10),
            legend.title = element_text(size = 12)
      )
  )
  return(plt)
}

# Summary plot for total number of cases in the recipient (by intervention)
resPlot_all <- function(scenario, results = res){
  tmp <- results %>% 
    filter(baseline == scenario) %>% 
    mutate(intensity = as.character((1-prop)*100), intv = factor(intv, levels = tab2$Type, labels = tab2$Intervention))
  plt <- (
    tmp %>% 
      ggplot(aes(x = intv, y = intensity, fill = cum_I_r)) +
      geom_tile(width = 0.95) +
      scale_fill_viridis_c(option = "E", begin = 0.98, end = 0.15,
                           name = "total cases in recipient") +
      scale_y_discrete(name = 'intervention intensity') +
      scale_x_discrete(name = 'intervention type') +
      coord_fixed(expand = FALSE) +
      theme_dviz_open(font_family = 'Arial') +
      theme(axis.line = element_blank(),
            axis.ticks = element_blank(),
            axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
            axis.text.y = element_text(size = 10),
            legend.title = element_text(size = 12)
      )
  )
  return(plt)
}