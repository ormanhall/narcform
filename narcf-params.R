library(rmarkdown)
library(here)
library(tidyverse)

###### Loading and preparing data #####
setwd("c:/narcforms")
read_csv(
    here::here("data", "forms.CSV")
    ) %>%
    mutate(
        KITS = as.numeric(KITS, na.rm = TRUE),
        KITS = ifelse(is.na(KITS), 0, KITS),
    ) %>%
    group_by(COUNTY, Program) %>%
    summarize(
        KITS = sum(KITS)
    ) -> forms

forms %>%
    group_by(COUNTY) %>%
    mutate(nprograms = n_distinct(Program))-> mydf

###### END ###########

forms %>%
    arrange(COUNTY, Program) -> forms

ids <- unique(forms$COUNTY)

for (i in seq_along(ids)) {
    myids <- ids[i]
    render("narcf-params.Rmd",
           params = list(mycounty = myids),
           output_format = pdf_document(latex_engine = 'pdflatex'),
           output_file = paste(myids, ' COUNTY', '.pdf', sep = ''),
           output_dir = 'PDFreports',
           quiet = TRUE,
           encoding = 'UTF-8')
    }


