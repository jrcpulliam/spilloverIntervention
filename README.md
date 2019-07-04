# Ecological interventions to prevent and manage pathogen spillover

This repository contains the code to reproduce the supplement for:

> Sokolow, SH, N Nova, K Pepin, AJ Peel, K Manlove, PC Cross, DJ Becker, RK Plowright, JRC Pulliam, H McCallum, and GA De Leo. (2019) Ecological interventions to prevent and manage pathogen spillover. _Phil Trans Roy Soc B_ doi:10.1098/rstb.2018.0342.

## Software

This code was written using R version 3.5.1 (2018-07-02)" ("Feather Spray"). The supplement was produced in R Studio version 1.1.456.

## Guide to running the code

We suggest you open the [R project file](./spilloverIntervetion.Rproj) in [R Sudio](http://rstudio.com/). The main file, which produces the supplemental information document, is [**spilloverIntervention.Rmd**](./spilloverIntervention.Rmd). Please view the file to see the package dependencies, which will need to be installed before you can run the analysis. Once you have installed the necessary packages, knitting this file to HTML will re-produce the supplemental information document. This file refers to the following other files, which you may want to explore further:

- [**helperFunctions.R**](./helperFunctions.R) - contains functions for the simulation that are not shown in the document
- [**plotFunctions.R**](./plotFunctions.R) - contains functions used for producing figures
- [**parameters.csv**](./parameters.csv) - table of parameters and parameter values that is read in for use in the simulations and parsed to create the tables in the document; contains parameter values for the two scenarios discussed in the article
- [**modelDiagram.png**](./modelDiagram.png) - a schematic representation of the model, which appears in the _Model structure_ section of the supplement
- [**simDat_EE.Rdata**](./simDat_EE.Rdata) - stored simulation output for the baseline case, as shown in the paper supplement; remove this file to run the simulations from scratch; EE indicates that the simulations are initiated at the endemic equilibrium for the reservoir host, as described in the _Model structure_ section of the supplement
- [**simDatIntervention_EE.Rdata**](./simDatIntervention_EE.Rdata) - stored simulation output (all intervention scenarios), as shown in the paper supplement; remove this file to run the simulations from scratch; EE indicates that the simulations are initiated at the endemic equilibrium for the reservoir host, as described in the _Model structure_ section of the supplement

## Customization

Control parameters are set on lines 45-50 of the Rmd file and can be adjusted by the user; they are:

- `SEED` - a seed for random number generation (default: 20190326)
- `REPS` - how many simulations to run for each scenarion (default: 1000)
- `TIMESTEP` - the time step, in days (default: 1); increase to speed up simulation run time (but note that results will be less precise)
- `YEARS` - time frame for each simulation run, in years (default: 5)
- `INITTYPE` - type of initialization (default: 'EE'); can also be set to 'DFE' to initiate the runs at the disease free equilibrium in the reservoir population
- `SIMID` - simulation ID to use for plotting (default: 8); can take on any integer value from 1 to REPS

Model parameters are read in from the [**parameters.csv**](./parameters.csv) file and should be modified by editing that file.

## License

See [this file](./LICENSE.md) for license information.