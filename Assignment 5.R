library(readr)
library(plyr)
library(tidyverse)



Nat2017 <- read_fwf("BED-2056/Nat2017PublicUS.c20180516.r20180808.txt",
                    fwf_positions(start = c(13, 475, 504),
                                  end = c(14, 475, 507),
                                  col_names = c("birth_month", "sex", "birth_weight")
                    )
)


#Finner antall gutter og jenter
sex_freq <- plyr::count(Nat2017$sex)

#Frekvensen av gutter til jenter
sex_prop <- sex_freq$freq[2]/sex_freq$freq[1]
#Proposjonen er ca. 1,048

#Setter birth_weight as.numeric
Nat2017$birth_weight <- as.numeric(Nat2017$birth_weight)

#Sorterer vekk "outliers"
Nat2017 <- filter(Nat2017, birth_weight > 1000 & birth_weight < 7000)

#Gjennomsnittlig f??dselsvekt
mean_weight <- mean(Nat2017$birth_weight)
# Svar: Gjennomsnittsvekten er 3279,41 gram

#Oppdaterer sex_freq etter filtrering
sex_freq <- plyr::count(Nat2017$sex)

#Lager denisty plot for gutter og jenter
ggplot(Nat2017, aes(x = birth_weight, color = sex)) +
  geom_density()+
  labs(title = "Density plot over f??dselsvekt mellom gutter og jenter",
       x = "F??dselsvekt",
       y = "Density")


#Gjennomsnittlig vekt per m??ned
avg_weight_per_month <- aggregate(birth_weight ~ birth_month, Nat2017, mean)

#Svar: GJennomsnittlige vekten variere i sv??rt liten grad mellom m??nedene

