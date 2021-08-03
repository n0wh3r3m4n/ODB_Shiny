if (!require(googlesheets4)) {
     install.packages("googlesheets4")
}
if (!require(httr)) {
  install.packages("httr")
}
if (!require(XML)) {
  install.packages("XML")
}
if (!require(ggplot2)) {
  install.packages("ggplot2")
}
library(googlesheets4)
library(httr)
library(XML)
library(ggplot2)

# Load World Bank data for all countries
# Starting with country classification

clasifica <- data.frame()
WBurl1 = "http://api.worldbank.org/v2/country"
for (i in 1:xmlAttrs(xmlRoot(xmlParse(WBurl1)))["pages"]) {
  a <- xmlToDataFrame(paste(WBurl1,"?page=",i,sep=""))
  clasifica <- rbind(clasifica,a)
}
clasifica <- clasifica[!clasifica$region=="Aggregates",-c(4,6:9)]
rm(WBurl1,a)

## Create dataframes with historical data for global and each of the dimensions

# Define content of each dataframe and create empty dataframes
var_odb <- c("Year","ISO2","ODB-Score-Scaled","Readiness-Scaled",
             "Implementation-Scaled","Impact-Scaled")
var_read <- c("Year","ISO2","Readiness-Scaled","Readiness-Government-Scaled",
              "Readiness-Policies-Scaled", "Readiness-Action-Scaled",
              "Readiness-Civil-Scaled","Readiness-Business-Scaled")
var_impl <- c("Year","ISO2","Implementation-Scaled","Implementation-Innovation-Scaled",
              "Implementation-Social-Scaled","Implementation-Accountability-Scaled",
              "Implementation-Datasets_Average-Scaled")
var_impa <- c("Year","ISO2","Impact-Scaled","Impact-Political-Scaled",
              "Impact-Social-Scaled","Impact-Economic-Scaled")
hist_odb <- data.frame()
hist_read <- data.frame()
hist_impl <- data.frame()
hist_impa <- data.frame()

# Load historical data from ILDAS's ODB google sheet
# Note you will need to login to your google account even though the spreadsheet is public

baseurl = "https://docs.google.com/spreadsheets/d/1CY0Wi7Kl1WKaS5cIdYFxh4knvwe6btA3f6XwH7fgSRo/edit"

for (i in c("2013","2014","2015","2016","2017","2020")) {
     # Import ODB sheets from each edition
     temp <- read_sheet(baseurl,sheet = paste("ODB-",i,"-Rankings",sep=""))
     # Add ISO2 country code to Namibia in missing years
     if (i == "2014" | i == "2015" | i == "2016") {
       temp[temp$Country=="Namibia",grep("^ISO2$",colnames(temp))] <- "NA"
     }
     # Duplicate Readiness Government as Policies & Action in 2013 and 2014 and add
     # "Government-Scaled" as average of Policies & Action in other years (to ease comparisons)
     if (i == "2013" | i == "2014") {
       temp$`Readiness-Policies-Scaled` <- temp$`Readiness-Government-Scaled`
       temp$`Readiness-Action-Scaled` <- temp$`Readiness-Government-Scaled`
     }
     if (i == "2015" | i == "2016" | i == "2017" | i == "2020") {
       temp$`Readiness-Government-Scaled` <- mean(c(temp$`Readiness-Policies-Scaled`,
                                                     temp$`Readiness-Action-Scaled`))
     }
     # Change name in Impact-Social in 2015
     if (i == "2015") {
       temp$`Impact-Social-Scaled` <- temp$`Impact-Social`
     }
     # Create empty vector for Implementation-Datasets_Average-Scaled in 2017
     # (seems that this was not measured in 2017)
     if (i == "2017") {
       temp$'Implementation-Datasets_Average-Scaled' <- NA
     }
     # Create historic ODB dataframes
     tempodb <- merge(temp[,var_odb],clasifica,by.x="ISO2",by.y="iso2Code",all.x=TRUE)
     hist_odb <- rbind(hist_odb,tempodb)
     tempread <- merge(temp[,var_read],clasifica,by.x="ISO2",by.y="iso2Code",all.x=TRUE)
     hist_read <- rbind(hist_read,tempread)
     tempimpl <- merge(temp[,var_impl],clasifica,by.x="ISO2",by.y="iso2Code",all.x=TRUE)
     hist_impl <- rbind(hist_impl,tempimpl)
     tempimpa <- merge(temp[,var_impa],clasifica,by.x="ISO2",by.y="iso2Code",all.x=TRUE)
     hist_impa <- rbind(hist_impa,tempimpa)
}

# Consolidate Europe, Central Asia and North America

hist_odb$region[hist_odb$region == "Europe & Central Asia" |
                  hist_odb$region == "North America"] <- "Europe, Central Asia & North America"

# Create name + Year

hist_odb$nameyear <- paste0(hist_odb$name," (",hist_odb$Year,")")

# Create entries in hist_odb for each region and year

for (i in unique(hist_odb$region)) {
  for (j in unique(hist_odb$Year)) {
    if (j == "2020" & i != "Latin America & Caribbean ") {
      break
      }
    tmpod <- mean(hist_odb$`ODB-Score-Scaled`[hist_odb$region== i & hist_odb$Year == j])
    tmprd <- mean(hist_odb$`Readiness-Scaled`[hist_odb$region== i & hist_odb$Year == j])
    tmpil <- mean(hist_odb$`Implementation-Scaled`[hist_odb$region== i & hist_odb$Year == j])
    tmpic <- mean(hist_odb$`Impact-Scaled`[hist_odb$region== i & hist_odb$Year == j])
    tmpnw <- data.frame(NA,j,tmpod,tmprd,tmpil,tmpic,i,i,NA,paste0(i," (",j,")"))
    names(tmpnw) <- names(hist_odb)
    hist_odb <- rbind(hist_odb,tmpnw)
  }
}
hist_odb[,c(3:6)] <- round(hist_odb[,c(3:6)],2)
hist_read[,c(3:6)] <- round(hist_read[,c(3:6)],2)
hist_impl[,c(3:6)] <- round(hist_impl[,c(3:6)],2)
hist_impa[,c(3:6)] <- round(hist_impa[,c(3:6)],2)

write.csv(hist_odb,"hist_odb.csv",row.names = FALSE)
write.csv(hist_read,"hist_read.csv",row.names = FALSE)
write.csv(hist_impl,"hist_impl.csv",row.names = FALSE)
write.csv(hist_impa,"hist_impa.csv",row.names = FALSE)

rm(baseurl,i,j,clasifica,temp,tempodb,tempread,tempimpl,tempimpa,
    tmpod,tmprd,tmpil,tmpic,tmpnw,
    var_odb,var_read,var_impl,var_impa,
    hist_odb,hist_read,hist_impl,hist_impa)

