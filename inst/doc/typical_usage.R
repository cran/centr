## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, results = 'hide', message = FALSE, warning = FALSE----------------
library(centr)
library(sf)
library(tidycensus)

NC_tracts <- get_decennial("tract", state = "NC", "P1_001N", year = 2020, geometry = TRUE)
NC_counties <- st_read(system.file("shape/nc.shp", package = "sf")) 

## -----------------------------------------------------------------------------
NC_tracts <- NC_tracts |>
  transform(GEOID_county = substring(GEOID, 1, 5)) |>
  subset(select = c(GEOID_county, value))

## ----error = TRUE-------------------------------------------------------------
mean_center(NC_tracts, group = "GEOID_county", weight = "value")

## -----------------------------------------------------------------------------
NC_tracts <- subset(NC_tracts, !st_is_empty(NC_tracts))

## -----------------------------------------------------------------------------
NC_county_means <- mean_center(NC_tracts, group = "GEOID_county", weight = "value")
NC_county_means

## -----------------------------------------------------------------------------
plot(st_geometry(NC_counties))
plot(st_geometry(NC_county_means), pch = 20, cex = 0.5, col = "red", add = TRUE)

## -----------------------------------------------------------------------------
NC_tracts_proj <- st_transform(NC_tracts, crs = "EPSG:32119")

NC_county_medians <- NC_tracts_proj |>
  median_center(group = "GEOID_county", weight = "value")
NC_county_medians

## -----------------------------------------------------------------------------
NC_counties_proj <- st_transform(NC_counties, crs = "EPSG:32119")

plot(st_geometry(NC_counties_proj))
plot(st_geometry(NC_county_medians), pch = 20, cex = 0.5, col = "red", add = TRUE)

