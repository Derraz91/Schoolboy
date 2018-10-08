library(readr)
library(tidyverse)
install.packages("rvest")
library(rvest)

stat <- read_html("https://w2.brreg.no/kunngjoring/kombisok.jsp?datoFra=01.01.2018&datoTil=08.10.2018&id_region=100&id_fylke=19&id_kommune=-+-+-&id_niva1=51&id_niva2=-+-+-&id_bransje1=0")

## finner fjerde tabell ved nettsiden

konkurser <- html_table(html_nodes(stat, "table")[[4]], fill = TRUE)

head(konkurser)


## sjekker lengeden p?? radene

num_rows <- nrow(konkurser)

## Rydder tomme kolonner og rader

konkurser <- konkurser[2:8]  

## kolonner og rader

konkurser <- slice(konkurser, 8:num_rows)

konkurser <- konkurser[-2] 

## Fjerner tomme kolonner

konkurser <- konkurser[-3] 

konkurser <- konkurser[-4]

## Nye navn p?? kolonner

head(konkurser)

colnames(konkurser) [1:4] <- c("firmar", "firma_nummer", "dato", "aktivitet")


## fjerne ledig plass og konverterer firma_nummer

konkurser$firma_nummer <- str_replace_all(string= konkurser$firma_nummer, pattern=" ", repl="")
konkurser$firma_nummer <- as.numeric(konkurser$firma_nummer)

## konverterer dato

konkurser$dato <- as.Date(konkurser$dato, "%d.%m.%Y")


## Fjerner personer i datasettet

konkurser <- konkurser %>%
  filter( nchar(firma_nummer) > 6)

ggplot() +
  geom_bar(data = konkurser, aes(aktivitet)) +
  labs(title = "konkurser og relaterte aktiviteter (01. januar. 2018 - 08. oktober. 2018)", x = "aktivitet", y = "antall")










