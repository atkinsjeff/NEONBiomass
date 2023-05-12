# NEONBiomass

This code used the Jenkins et al. 2003 allometric equations fit to NEON taxon ID
information for NEON sites using the NEON data formatting and structure. 

It is a sketch that works up biomass estimates in kg (I think) for the Harvard Forest
(HARV) terrestrial observation plots for 2019-2021.


References:
Jenkins, J. C., Chojnacky, D. C., Heath, L. S., & Birdsey, R. A. (2003). National-scale biomass estimators for United States tree species. Forest science, 49(1), 12-35.

## Additional Notes
The Jenkins allometric equations classify trees into several groups (e.g., mixed hardwood,
pine, woodland) with a specific equation of the form:  


$$\LARGE e^{\beta_{1} + \beta_{2} \ln dbh} $$  

Where ${\beta_{1}}$ and ${\beta_{2}}$ are the group specific coefficients and $dbh$ is
the diameter-at-breast height in cm.

