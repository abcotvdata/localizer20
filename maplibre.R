library(maplibregl)

map <- maplibregl(
  center = c(-73.9165, 40.7114),
  zoom = 10,
  pitch = 30
)

if (interactive()) map
map

devtools::install_github("crazycapivara/openlayers", ref = "develop")
library(openlayers)
#> openlayers 0.5.0 wrapping openlayersjs v4.6.4
ol() %>%
  add_stamen_tiles() %>%
  set_view(9.5, 51.31667, zoom = 10)

## Points
library("geojsonio")

cities <- us_cities[1:5, ]

ol()  %>%
  add_stamen_tiles() %>%
  add_features(cities, style = icon_style(),
               popup = cities$name)

## Polygons
library("sf")

nc <- st_read(system.file("gpkg/nc.gpkg", package = "sf"),
              quiet = TRUE)

ol() %>%
  add_stamen_tiles("toner") %>%
  add_stamen_tiles(
    "terrain-labels",
    options = layer_options(max_resolution = 13000)
  ) %>%
  add_features(
    data = nc,
    options = layer_options(opacity=0.3),
    style = fill_style("yellow") + stroke_style("blue", 1),
    popup = nc$AREA  
  ) %>%
  add_overview_map()