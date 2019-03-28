# Ecological interventions to prevent and manage pathogen spillover

> Sokolow, SH, N Nova, K Pepin, AJ Peel, K Manlove, PC Cross, DJ Becker, RK Plowright, JRC Pulliam, H McCallum, and GA De Leo. In prep. Ecological interventions to prevent and manage pathogen spillover. _Phil Trans Roy Soc B_ doi:10.1098/not yet assigned.

## Notes for co-authors

#### Changes from original model

- Total birth rate now proportional to N, not S (for r and d), so population size is (on average) constant (NB: this was previously the case in the code but not indicated in the equations)
- Initialize simulations at EE for donor population and DFE for recipient population; skip annual reintroductions (NB: the logic here is that the donor host is the "reservoir" and - more importantly - that the reintroduction isn't represented in the equations that are specified; if we have them, we should make it explicit in the ODEs so that the model is internally consistent)
- Increased the duration of infection in donor from 12 to 21 to get a higher I_d at EE for example 2
- Treatment interventions now _decrease_ (not increase) the duration of infection (NB: not 100\% certain what was done previously because I'm rusty on matlab but the comment indicated the effect was to increase the duration of infection)
- Reducing the d-d contact was previously referred to as "food distribution - donor" and r-r contact rate as "movement restriction - recipient"; I've reframed these as "behavior manipulation of donor" and "behavior modification or recipient"; we can add some examples in the SI text to clarify (e.g. "via food distribution" for the former and "via social distancing or movement restrictions" for the latter)

#### Suggested additional changes

- Switch from density-dependent to frequency-dependent transmission; difference should be minor but may reduce variation between runs because population size (which varies stochastically) currently affects reproduction number.
- Need to decide how to implement vaccination. The original version reduces both of the transmission probabilities to recipient, but this is not consistent with how it's represented in the equations and is mechanistically odd. Text currently states that vaccination rates are calculated from weekly probabilities (this is not actually implemented; both this and the current implementation are different from the original version). My preference would be to switch the model formulation so that vaccination is strictly a proportion and is applied at birth; this will allow the intervention scaling to be more natural and is straight-forward to implement.
- Would be cleaner to specify R0 values and calculated the contact rates from these and other parameters; currently this is done in defining the parameter table so is not explicit and doesn't allow tweaking R0 directly in the code, only via contact rate.
- Should effect on birth rate be calculated via decrease in 1/rate so that this is more comparable to how culling is implemented?

#### To do

- Move parameter adjustments from helperFunctions to the main file?
- Fully specify initial conditions under "Model structure"?
- Figure and table captions
- Figures for main text
- Add references and all package specifications
- Adjust aspect ratios of figures?
- Deal with seed change issue
- Reorder (and relabel?) legend; fix placement / scaling issue
