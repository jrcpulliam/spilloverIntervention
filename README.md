# Ecological interventions to prevent and manage pathogen spillover

> Sokolow, SH, N Nova, K Pepin, AJ Peel, K Manlove, PC Cross, DJ Becker, RK Plowright, JRC Pulliam, H McCallum, and GA De Leo. In prep. Ecological interventions to prevent and manage pathogen spillover. _Phil Trans Roy Soc B_ doi:10.1098/not yet assigned.

## Notes for co-authors

#### Changes from original model

- Total birth rate now proportional to N, not S (for r and d), so population size is (on average) constant
    - This was previously the case in the code but not indicated in the equations
- Initialize simulations at EE for donor population and DFE for recipient population
- Reducing the d-d contact was previously referred to as "food distribution - donor" and r-r contact rate as "movement restriction - recipient"; I've reframed these as "behavior manipulation of donor" and "behavior modification or recipient"; we can add some examples in the SI text to clarify (e.g. "via food distribution" for the former and "via social distancing or movement restrictions" for the latter)

#### Suggested additional changes

- Both vaccination and culling should be set as annual probabilities/fractions and converted to daily hazards

#### Interesting things to examine further

- Switch from density-dependent to frequency-dependent transmission; does this change the effectiveness of culling?
- Vaccination at birth rather than continuously
- Incorporation of density-dependent birth processes

#### To do

- Revert duration of infection in donor for Example 2 from 21 to 12
- Simplify transmission coefficient to beta
- Specify R0 values and calculated the contact rates from these and other parameters
- Add reintroduction process to model (rate comparable to 5 introductions per year for both examples); add some text explaining this
- Add text clarifying contact terms
- Change the way that vaccination and culling scale with "intensity"
- Move parameter adjustments from helperFunctions to the main file
- Clarify scalings in ODE or table
- Fully specify initial conditions under "Model structure"
- Figure and table captions
- Figures for main text
- Add references and all package specifications
- Adjust aspect ratios of figures?
- Deal with seed change issue
- Reorder (and relabel?) legend; fix placement / scaling issue
