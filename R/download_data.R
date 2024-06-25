
## Load packages
library(geodata)
library(readr)
library(sf)
library(dplyr)

## Search occurrences
cerambyx_po <- geodata::sp_occurrence(
    genus   = "Cerambyx",
    species = "cerdo",
    args    = c("country=PT")
)

## Search occurences in Spain
cerambyx_esp <- geodata::sp_occurrence(
    genus   = "Cerambyx",
    species = "cerdo",
    args    = c("country=ES")
)

cerambyx <- bind_rows(cerambyx_esp, cerambyx_po) |>
    select(lon, lat, year, basisOfRecord, verbatimLocality) |>
    st_as_sf(coords = c("lon", "lat"), crs = 4326) |>
    mutate(
        year = as.factor(year)
    )

write_rds(cerambyx, "data/cerambyx.rds")


