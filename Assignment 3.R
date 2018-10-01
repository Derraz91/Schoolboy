options(encoding = "UTF-8")
library(httr)
library(rjstat)
library(tidyverse)
library(dplyr)

## last inn data for fylker

jsonfylke <- "http://data.ssb.no/api/v0/dataset/95274.json?lang=no"

dftempfylke <- GET(jsonfylke)

dfjsonfylke <- fromJSONstat(content(dftempfylke, "text"))

dfjsonfylke <- dfjsonfylke[[1]]

## last inn data for hele landet


jsonlandet <- "http://data.ssb.no/api/v0/dataset/95276.json?lang=no"

dftemplandet <- GET(jsonlandet)

dfjsonlandet <- fromJSONstat(content(dftemplandet, "text"))

dflandet <- dfjsonlandet[[1]]

## Kombinere de to datasettene

dfcomb <- left_join(dfjsonfylke, dflandet, c("måned", "statistikkvariabel"))


## Separerer datasett måned, til år og måned

dfcomb <- separate(dfcomb, måned into = c("år, "måned"), sep = "M")
                                          
## flitrer vekk verdier på null(0)
                                          
dfcomb <- dfcomb %>%
filter(!(value.x <= 0))
