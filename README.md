# Ecological interventions to prevent and manage pathogen spillover

> Sokolow, SH, N Nova, K Pepin, AJ Peel, K Manlove, PC Cross, DJ Becker, RK Plowright, JRC Pulliam, H McCallum, and GA De Leo. In prep. Ecological interventions to prevent and manage pathogen spillover. _Phil Trans Roy Soc B_ doi:10.1098/not yet assigned.

## Notes for co-authors

#### Changes from original model

- Total birth rate now proportional to N, not S (for r and d), so population size is (on average) constant (NB: this was previously the case in the code but not indicated in the equations)
- Initialize simulations at EE for donor population and DFE for recipient population; skip annual reintroductions
- Increased the duration of infection in donor from 12 to 21 to get a higher I_d at EE for example 2
- Vaccination rates calculated from weekly probabilities

#### Suggested additional changes

- Adjust scaling of parameter values (???)
