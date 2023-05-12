# NEONBiomass

This code uses the Jenkins et al. 2003 allometric equations fit to NEON taxon ID
information for NEON sites using the NEON data formatting and structure.  

It is a sketch that works up biomass estimates in kg (I think) for the Harvard Forest
(HARV) terrestrial observation plots for 2019-2021.


## Additional Notes
The Jenkins allometric equations classify trees into several groups (e.g., mixed hardwood,
pine, woodland) with a specific equation of the form:  


$$\LARGE e^{\beta_{1} + \beta_{2} \ln dbh}$$  

Where ${\beta_{1}}$ and ${\beta_{2}}$ are the group specific coefficients and $dbh$ is
the diameter-at-breast height in cm.  

Individual trees in the NEON data set are assigned a `taxonID` which was used to match with 
the assigned groups from Jenkins et al. 2003 (further species classification information is provided
in the manuscript). However, where there was no initially obvious classification group that could be assigned,
the USDA PLANTS database and other sources were consulted and a best guess was made. Please feel free
to offer suggestions for improvements.  

Taxon classification information is found in the `./data/neon_taxon_jenkins.csv` file.  

Note, this only includes species/taxons present in NEON sites used in the 
Atkins et al. 2018 and Gough et al. 2019 papers from the Midwest, Northeast, Mid-Atlantic and Southeast 
regions of the US:  

BART (Bartlett Experimental Forest), GRSM (Great Smoky Mountains), HARV (Harvard Forest),
MLBS (Mountain Lake Biological Station), OSBS (Ordway-Swisher Biological Station), SCBI 
(Smithsonian Conservation Biological Institute), SERC (Smithsonian Environmental Research Center),
TALL (Talladega National Forest), TREE (Treehaven), UNDE (University of Notre Dame Environmental Research Center).  
  
  
## References:  

Atkins, J. W., Fahey, R. T., Hardiman, B. S., & Gough, C. M. (2018). Forest canopy structural complexity and light absorption relationships at the subcontinental scale. Journal of Geophysical Research: Biogeosciences, 123(4), 1387-1405.  

Gough, C. M., Atkins, J. W., Fahey, R. T., & Hardiman, B. S. (2019). High rates of primary production in structurally complex forests.  

Jenkins, J. C., Chojnacky, D. C., Heath, L. S., & Birdsey, R. A. (2003). National-scale biomass estimators for United States tree species. Forest science, 49(1), 12-35.
