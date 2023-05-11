#### BIOMASS Calculaions from NEON data for Harvard as example using Jenkins et al. 2003
# Jenkins, J. C., Chojnacky, D. C., Heath, L. S., & Birdsey, R. A. (2003).
# National-scale biomass estimators for United States tree species. 
# Forest science, 49(1), 12-35.

# packages
require(plyr)
require(dplyr)
require(tidyverse)
require(data.table)



## notes
# from what I can tell the uid is a unique id for each data row or sample
# whereas individualID is the ID for each tree.

#### MAPPING INFORMATION
harv.map <- read.csv("./data/HARV/NEON.D01.HARV.DP1.10098.001.vst_mappingandtagging.basic.20230109T190320Z.csv")

#### Data files in directory
filenames <- list.files('./data/HARV/', 
                        pattern = "apparentindividual", recursive = TRUE, full.names = TRUE) 

# rbind them together
ans <- rbindlist(lapply(filenames, fread))


##### merge only what we need
harv <- merge(ans[ , c("individualID", "siteID", "plotID", "date", "plantStatus","growthForm", "stemDiameter")],
              harv.map[ , c("individualID", "taxonID",  "stemDistance", "stemAzimuth")], 
              by = c("individualID"), all.x = TRUE)

# add the year
harv$year <- as.factor(substr(harv$date, 0, 4))

# filter to only trees
harv %>%
  filter(str_detect(growthForm, "tree")) %>%
  data.frame() -> df


#####################################
#bring in jenkins model

jenkins_model <- c("aspen/alder/cottonwood/willow", "soft maple/birch", "mixed hardwood", "hard maple/oak/hickory/beech", "cedar/larch", "doug fir", "fir/hemlock", "pine", "spruce", "juniper/oak/mesquite")
model_name <- c("hw1", "hw2", "hw3", "hw4", "sw1", "sw2", "sw3", "sw4", "sw5", "wl")
beta_one <- c(-2.20294, -1.9123, -2.4800, -2.0127, -2.0336, -2.2304, -2.5384, -2.5356, -2.0773, -0.7152)
beta_two <- c(2.3867, 2.3651, 2.4835, 2.4342, 2.2592, 2.4435, 2.4814, 2.4349, 2.3323, 1.7029)

jenkins <- data.frame(jenkins_model, model_name, beta_one, beta_two)

# bring in file the connects taxons to Jenkins model
tax.jenk <- read.csv("./data/neon_taxon_jenkins.csv")

jenkins_plus <- merge(tax.jenk, jenkins)

# then merge together
df <- merge(df, jenkins_plus, by = "taxonID", all.x = TRUE)




###########
# biomass should be in kg i think. this comes from jennifer jenkins 2003 paper

df$biomass <- exp(df$beta_one + (df$beta_two * log(df$stemDiameter)))






###### IMPORTANT
###### when you get to npp you have to account for the neon plot design
###### if you want to get normalized npp. neon does a 40 x 40 m plot design
###### but only does two 20 x 20 m quadrats of that plot. so i think these are right 
###### at the "plot" level which for DBH msmts of trees is 800 m^2, not the full
###### 1600. 

# # change to per hectare
# plot.npp$npp <- plot.npp$npp * 12.5
# 
# # change to Mg per hectare
# plot.npp$npp <- plot.npp$npp * 0.001
# 




### old code, some will be useful ####
# #######
# 
# 
# big.boi %>%
#   group_by(siteid) %>%
#   summarise_all(funs(mean, sd)) -> site.means
# 
# site.means <- data.frame(site.means)
# 
# head(site.means)
# 
# write.csv(site.means, "neon_csc_npp_means.csv")
# write.csv(plot.npp, "neon_plot_npp.csv")
# 
# #get a count
# big.boi %>%
#   group_by(siteid) %>%
#   summarize(no = n()) -> no.site
# 
# npp.label <- expression(paste("NPP"[Wood]~"( Mg Ha"^-1~")"))
# 
# # get a SE for rugosity
# site.means$rugosity_se <- site.means$rugosity_sd / sqrt(site.means$no)
# site.means$npp_se <- site.means$npp_sd / sqrt(site.means$no)
# site.means$vai_se <- site.means$mean.vai_sd / sqrt(site.means$no)
# 
# 
# site.means <- cbind(site.means, no.site) 
# # colors
# # The palette with black:
# cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
# 
# # To use for fills, add
# scale_fill_manual(values=cbPalette)
# 
# # To use for line and point colors, add
# scale_colour_manual(values=cbPalette)
# 
# ggplot(site.means, aes(x = rugosity_mean, y = npp_mean))+
#   geom_errorbarh(aes(xmin = rugosity_mean - rugosity_se, xmax = rugosity_mean + rugosity_se))+
#   geom_errorbar(aes(ymin = npp_mean - npp_se, ymax = npp_mean + npp_se))+
#   geom_point(aes(color=siteid), size = 5)+
#   geom_point(shape = 1, size = 5, color = "black")+
#   scale_colour_manual(values=cbPalette)+
#   theme_classic()+
#   theme(axis.title = element_text(size = 16),
#         axis.text = element_text(size = 12))+
#   theme(legend.title=element_blank())+
#   ylab(npp.label)+
#   xlab("Canopy Rugosity (m)")+
#   stat_smooth(method = "lm", se = FALSE)
# 
# 
# ggplot(site.means, aes(x = mean.vai_mean, y = npp_mean))+
#   geom_errorbarh(aes(xmin = mean.vai_mean - vai_se, xmax = mean.vai_mean + vai_se))+
#   geom_errorbar(aes(ymin = npp_mean - npp_se, ymax = npp_mean + npp_se))+
#   geom_point(aes(color=siteid), size = 5)+
#   geom_point(shape = 1, size = 5, color = "black")+
#   scale_colour_manual(values=cbPalette)+
#   theme_classic()+
#   theme(axis.title = element_text(size = 16),
#         axis.text = element_text(size = 12))+
#   theme(legend.title=element_blank())+
#   ylab(npp.label)+
#   xlab("VAI")
# 
# ggsave("npp_rugosity.png", units="in", width=5, height= 5, dpi=300)
# png('npp_rugosity.png', units="in", width=5, height=5, res=300)
# #insert ggplot code
# dev.off()
# 
# lm.rc.site <- lm(npp_mean ~ rugosity_mean, data = site.means)
# lm.vai.site <- lm(npp_mean ~ mean.vai_mean, data = site.means)
# 
# summary(lm.rc.site)
# m <- 
#   nls.rc.site <- nls(npp_mean ~ rugosity_mean, data = site.means)
# 
# 
# ####
# div.lite <- site.diversity[,c(1, 3:12)]
# 
# div.lite %>%
#   filter(!siteid == "MLBS") -> div.lite2
# site.all <- cbind(site.means, div.lite2)
# 
# ###
# ggplot(site.all, aes(x = shannon.genus_mean, y = npp_mean))+
#   # geom_errorbarh(aes(xmin = rugosity_mean - rugosity_se, xmax = rugosity_mean + rugosity_se))+
#   # geom_errorbar(aes(ymin = npp_mean - npp_se, ymax = npp_mean + npp_se))+
#   geom_point(aes(color=siteid), size = 5)+
#   geom_point(shape = 1, size = 5, color = "black")+
#   scale_colour_manual(values=cbPalette)+
#   theme_classic()+
#   theme(axis.title = element_text(size = 16),
#         axis.text = element_text(size = 12))+
#   theme(legend.title=element_blank())+
#   ylab(npp.label)+
#   xlab("Shannon Diversity Index")+
#   stat_smooth(method = "lm", se = FALSE)
# 
# lm.shannon <- lm(npp_mean ~ shannon.genus_mean, data = site.all)
# summary(lm.shannon)
# 
# ggplot(site.all, aes(y = rugosity_mean, x = shannon.genus_mean))+
#   # geom_errorbarh(aes(xmin = rugosity_mean - rugosity_se, xmax = rugosity_mean + rugosity_se))+
#   # geom_errorbar(aes(ymin = npp_mean - npp_se, ymax = npp_mean + npp_se))+
#   geom_point(aes(color=siteid), size = 5)+
#   geom_point(shape = 1, size = 5, color = "black")+
#   scale_colour_manual(values=cbPalette)+
#   theme_classic()+
#   theme(axis.title = element_text(size = 16),
#         axis.text = element_text(size = 12))+
#   theme(legend.title=element_blank())+
#   xlab("Shannon Diversity Index")+
#   ylab("Canopy Rugosity (m)")+
#   stat_smooth(method = "lm", se = FALSE)
# 
# lm.shan.rc <- lm(rugosity_mean ~ shannon.genus_mean, data = site.all)
# summary(lm.shan.rc)
# 
# write.csv(site.all, "neon_csc_npp_means.csv")
# 
