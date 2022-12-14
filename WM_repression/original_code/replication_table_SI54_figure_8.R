

#********************************************************************************************
#
# Title:    INTERNATIONAL SPORTS EVENTS AND REPRESSION IN AUTOCRACIES: 
#           EVIDENCE FROM THE 1978 FIFA WORLD CUP
#
# Authors:  Adam Scharpf, Christian Glaessel, Pearce Edwards
#
# Journal:  American Political Science Review
#
# Date:     July 2022
#
#********************************************************************************************
#
# Content:  Replication of Figure 8 and Table SI.5.4.
#
#********************************************************************************************
#
# Notes:    1) The following analyses were carried out using R version 4.1.1, R Studio version 1.4.1717
#           2) Read the file "readme.txt"
#           3) Run the STATA file "replication.do"
#           4) If necessary, install the required R packages (by uncommenting and running line 37 in this R script) 
#           5) Run this R Script (this R script and the data files must be in the same folder)
#
#********************************************************************************************

rm(list=ls(all=TRUE))




#********************************************************************************************
# Packages 
#********************************************************************************************

#install.packages(c("foreign", "texreg", "plotly", "readstata13", "readstata13", "MASS", "ggplot2", "arm", "pscl", "gam", "mgcv", "knitr", "itsadug", "xtable", "lattice"))
require(foreign)        # version: 0.8-81
require(texreg)         # version: 1.37.5
library(plotly)         # version: 4.9.3
library(readstata13)    # version: 0.9.2
require(MASS)           # version: 7.3-53.1
require(ggplot2)        # version: 3.3.3
require(arm)            # version: 1.11-2
require(pscl)           # version: 1.5.5
require(gam)            # version: 1.20
require(mgcv)           # version: 1.8-35
require(knitr)          # version: 1.33
require(itsadug)        # version: 2.4
require(xtable)         # version: 1.8-4
require(lattice)        # version: 0.20-41




#********************************************************************************************
# Working directory
#********************************************************************************************

# Set the working directory to the folder you opened the script. 
# Alternatively, you may specify the file path using the function setwd()

set_wd <- function() {
        current_path <- getActiveDocumentContext()$path 
        setwd(dirname(current_path ))
        print( getwd() )
}

getwd()





#********************************************************************************************
# Read data
#********************************************************************************************

df <- read.dta13("main_data.dta")

attach(df)





################################################################################
# Models 1-3 (Table SI.5.4):    Generalized additive regression results for proximity 
#                               to nearest journalist hotel and time
################################################################################

###########################################################
# Model 1

# Subset variables to be included in the model
df.gam1 <- na.omit(as.data.frame(cbind(df$time, 
                                       df$prox_hotelonly, 
                                       df$lnrepression
                                       )))

# Assign column names  
colnames(df.gam1) <- c("time",
                       "prox_hotelonly",
                       "lnrepression"
                       )

# GAM model
mgam1 <- gam(lnrepression ~ te(time, prox_hotelonly),
             family=gaussian,
             data = df.gam1
            )

# Show GAM regression results
summary(mgam1)


###########################################################
# Model 2

# Subset variables to be included in the model
df.gam2 <- na.omit(as.data.frame(cbind(df$time, 
                                       df$prox_hotelonly, 
                                       df$lnrepression,
                                       df$lnpop_1970, 
                                       df$vote_frejuli, 
                                       df$literacy_avg,
                                       df$lnrebact1974, 
                                       df$lnrepression70_77
                                       )))

# Assign column names 
colnames(df.gam2) <- c("time",
                       "prox_hotelonly",
                       "lnrepression",
                       "lnpop_1970",
                       "vote_frejuli",
                       "literacy_avg",
                       "lnrebact1974",
                       "lnrepression70_77"
                       )

# GAM model
mgam2 <- gam(lnrepression ~ te(time, prox_hotelonly)+
                     lnpop_1970+
                     vote_frejuli+
                     literacy_avg+ 
                     lnrebact1974+ 
                     lnrepression70_77,
                     family="gaussian",
                     data = df.gam2
                     )

# Show GAM regression results
summary(mgam2)


###########################################################
# Model 3

# Subset variables to be included in the model
df.gam3 <- na.omit(as.data.frame(cbind(df$time, 
                                       df$prox_hotelonly, 
                                       df$lnrepression,
                                       df$lnpop_1970, 
                                       df$vote_frejuli, 
                                       df$literacy_avg,
                                       df$lnrebact1974, 
                                       df$lnrepression70_77, 
                                       zone2,
                                       zone3, 
                                       zone4, 
                                       zone5
                                       )))

# Assign column names 
colnames(df.gam3) <- c("time",
                       "prox_hotelonly",
                       "lnrepression",
                       "lnpop_1970",
                       "vote_frejuli",
                       "literacy_avg",
                       "lnrebact1974",
                       "lnrepression70_77",
                       "zone2",
                       "zone3",
                       "zone4",
                       "zone5"
                       )

# GAM model
mgam3 <- gam(lnrepression ~ te(time, prox_hotelonly)+ 
                     lnpop_1970+
                     vote_frejuli+
                     literacy_avg+ 
                     lnrebact1974+ 
                     lnrepression70_77+
                     zone2+
                     zone3+
                     zone4+
                     zone5, 
                     family="gaussian",
                     data = df.gam3
                     )

# Show GAM regression results
summary(mgam3)





################################################################################
# Models 4-6 (Table SI.5.4):    Generalized additive regression results for proximity to 
#                               nearest journalist venue (journalist hotel OR team hotel 
#                               of a democratic competing country OR press center) and time
################################################################################

###########################################################
# Model 4

# Subset variables to be included in the model
df.gam4 <- na.omit(as.data.frame(cbind(df$time, 
                                       df$prox_hotelpress, 
                                       df$lnrepression
                                       )))

# Assign column names 
colnames(df.gam4) <- c("time",
                       "prox_hotelpress",
                       "lnrepression"
                       )

# GAM model
mgam4 <- gam(lnrepression ~ te(time, prox_hotelpress),
             family="gaussian",
             data = df.gam4
             )

# Show GAM regression results
summary(mgam4)



###########################################################
# Model 5

# Subset variables to be included in the model
df.gam5 <- na.omit(as.data.frame(cbind(df$time, 
                                       df$prox_hotelpress, 
                                       df$lnrepression,
                                       df$lnpop_1970, 
                                       df$vote_frejuli, 
                                       df$literacy_avg,
                                       df$lnrebact1974, 
                                       df$lnrepression70_77
                                       )))

# Assign column names 
colnames(df.gam5) <- c("time",
                       "prox_hotelpress",
                       "lnrepression",
                       "lnpop_1970",
                       "vote_frejuli",
                       "literacy_avg",
                       "lnrebact1974",
                       "lnrepression70_77"
                       )

# GAM model
mgam5 <- gam(lnrepression ~ te(time, prox_hotelpress)+ 
                     lnpop_1970+
                     vote_frejuli+
                     literacy_avg+ 
                     lnrebact1974+ 
                     lnrepression70_77,
                     family="gaussian",
                     data = df.gam5
                     )

# Show GAM regression results
summary(mgam5)



###########################################################
# Model 6

# Subset variables to be included in the model
df.gam6 <- na.omit(as.data.frame(cbind(df$time, 
                                       df$prox_hotelpress, 
                                       df$lnrepression,
                                       df$lnpop_1970, 
                                       df$vote_frejuli, 
                                       df$literacy_avg,
                                       df$lnrebact1974, 
                                       df$lnrepression70_77, 
                                       zone2,
                                       zone3, 
                                       zone4, 
                                       zone5
                                       )))

# Assign column names 
colnames(df.gam6) <- c("time",
                       "prox_hotelpress",
                       "lnrepression",
                       "lnpop_1970",
                       "vote_frejuli",
                       "literacy_avg",
                       "lnrebact1974",
                       "lnrepression70_77",
                       "zone2",
                       "zone3",
                       "zone4",
                       "zone5"
                       )

# GAM model
mgam6 <- gam(lnrepression ~ te(time, prox_hotelpress)+ 
                     lnpop_1970+
                     vote_frejuli+
                     literacy_avg+ 
                     lnrebact1974+ 
                     lnrepression70_77+
                     zone2+
                     zone3+
                     zone4+
                     zone5, 
                     family="gaussian",
                     data = df.gam6
                     )

# Show GAM regression results
summary(mgam6)






################################################################################
# Replication of Table SI.5.4
################################################################################

# Define list of coefficient names
coefnames <- list("EDF: te(time,prox_hotelonly)" = "EDF: te(Proximity to Journalist Hotel, Time)",
                  "EDF: te(time,prox_hotelpress)" = "EDF: te(Proximity to Journalist Venue, Time)",
                  lnpop_1970 = "Population Size", 
                  literacy_avg = "Literacy Rate", 
                  vote_frejuli = "Peronist Vote Share", 
                  rebact1974 = "Rebel Activity", 
                  lnrepression70_77 = "Past Repression"
                  ) 

# Define list of vectors indicating whether models employ 'Zone Fixed Effects'   
zonefix <- list("Zone Fixed Effects" = c("No", 
                                         "No", 
                                         "Yes", 
                                         "No", 
                                         "No", 
                                         "Yes"
                                         ))

# Create Table SI.5.4
texreg(list(extract(mgam1),
            extract(mgam2),
            extract(mgam3), 
            extract(mgam4),
            extract(mgam5),
            extract(mgam6)), 
       caption = "Generalized additive regression results for proximity to nearest journalist hotel/venue",
       dcolumn = TRUE, 
       booktabs = TRUE, 
       sideways= TRUE,
       label = "tab_gams", 
       custom.coef.map = coefnames,
       custom.gof.rows = zonefix,
       digits=3,
       file= "table_SI54.tex"
)



################################################################################
# Replication of Figure 8 (based on Model 3 in Table SI.5.4)
################################################################################

# Create Figure 8 based on Model 3
vis.gam(mgam3, view = c("time", "prox_hotelonly"), 
        n.grid=50, 
        color="bw", 
        plot.type="persp",
        type="link",
        xlab = list("\n Time", cex.lab=1.3),
        ylab = list("\n Proximity to Journalist Hotel", cex.lab=1.3),
        zlab = list("\n Repression", cex.lab=1.3),
        box=TRUE,
        theta = 410,
        phi=25
)





