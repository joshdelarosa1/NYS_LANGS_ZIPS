#install.packages("dplyr")
#install.packages("sf")
#install.packages("tidycensus")
#install.packages("tidyverse")
#install.packages("reshape2")
#install.packages("formattable")
#install.packages("openxlsx")

setwd('/Users/josuedelarosa/dev/NYC_lang')
getwd()


library(tidycensus)
library(tidyverse)
library(sf)
library(reshape2)
options(tigris_use_cache = TRUE)
library(formattable)
library(openxlsx)


var15 <- load_variables(2015, "acs5", cache = TRUE)

View(var15)


LANGS <- c(   population= "B16001_001",
              Spanish = "B16001_005E",
              French=   "B16001_008E",
              French_Creole =  "B16001_011E", 
              Yiddish = "B16001_023E", 
              Greek=    "B16001_032E",
              Russian = "B16001_035E",
              Polish=   "B16001_038E",
              Hindi=    "B16001_056E",
              Urdu =    "B16001_059E",
              Chinese=  "B16001_068E",
              Korean=   "B16001_074E",
              Tagalog=  "B16001_095E",
              Arabic=   "B16001_110E",
              Hebrew=   "B16001_113E"
          )

#NY_Lang_tracts <- get_acs(survey = "acs5",year=2015, geography = "tract", variables = LANGS, 
#                        state = "36",  geometry = FALSE,
#                       summary_var = "B16001_001") 

#head(NY_Lang_tracts)

#st_write(NY_Lang_tracts, "./NY_Lang_tracts.shp")

Lang_zip <- get_acs(survey = "acs5",year=2015, geography = "zip code tabulation area", variables = LANGS, 
                    geometry = FALSE) 


head(Lang_zip)

Lang_zipw <- dcast(Lang_zip, GEOID + NAME ~variable, value.var = "estimate")
str(Lang_zipw)

names(Lang_zipw) <- c("ZIP.Code","ZIP_NAME","Spanish","French","French_Creole","Yiddish","Greek","Russian","Polish",
                      "Hindi","Urdu","Chinese","Korean","Tagalog","Arabic","Hebrew","population")


Lang_zipw$spanish_pct <- percent((Lang_zipw$Spanish / Lang_zipw$population))
Lang_zipw$French_pct <- percent((Lang_zipw$French / Lang_zipw$population))
Lang_zipw$French_Creole_pct <- percent((Lang_zipw$French_Creole / Lang_zipw$population))
Lang_zipw$Yiddish_pct <- percent((Lang_zipw$Yiddish / Lang_zipw$population))
Lang_zipw$Russian_pct <- percent((Lang_zipw$Russian/ Lang_zipw$population))
Lang_zipw$Greek_pct <- percent((Lang_zipw$Greek/ Lang_zipw$population))
Lang_zipw$Polish_pct <- percent((Lang_zipw$Polish/ Lang_zipw$population))
Lang_zipw$Hindi_pct <- percent((Lang_zipw$Hindi/ Lang_zipw$population))
Lang_zipw$Urdu_pct <- percent((Lang_zipw$Urdu/ Lang_zipw$population))
Lang_zipw$Korean_pct <- percent((Lang_zipw$Korean/ Lang_zipw$population))
Lang_zipw$Chinese_pct <- percent((Lang_zipw$Chinese/ Lang_zipw$population))
Lang_zipw$Tagalog_pct <- percent((Lang_zipw$Tagalog/ Lang_zipw$population))
Lang_zipw$Arabic_pct <- percent((Lang_zipw$Arabic/ Lang_zipw$population))
Lang_zipw$Hebrew_pct <- percent((Lang_zipw$Hebrew/ Lang_zipw$population))



NYS_ZIPS= read.csv("https://data.ny.gov/api/views/juva-r6g2/rows.csv?accessType=DOWNLOAD")  


NYS_ZIP_LANGS<-merge(NYS_ZIPS, Lang_zipw, by = "ZIP.Code")
NYS_ZIP_LANGS$File.Date <- NULL
NYS_ZIP_LANGS$ZIP_NAME <- NULL
NYS_ZIP_LANGS<-NYS_ZIP_LANGS[!(NYS_ZIP_LANGS$population=="0"),]


head(NYS_ZIP_LANGS)


write.xlsx(NYS_ZIP_LANGS, '/Users/josuedelarosa/dev/NYC_lang/NYS_Langs_ZIPS.xlsx')


#can't use .shp in tableau 10.1 or less
#st_write(Lang_zip, "./Lang_zip.shp")


