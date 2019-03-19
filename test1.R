library(rgeos)
library(rgdal)
library(maptools)
library(tidyr)
library(broom)
library(ggplot2)
library(raster)



#-----------------------------------------------------------------------------------------------------#
# Dissolve sulla base di un codice già esistente
#-----------------------------------------------------------------------------------------------------#

# Carico lo shapefile nell'environment 
shape <- readOGR("Com2016_WGS84_g")
#shape@data$id <- rownames(shape@data)

# Unisco i poligoni dello shapefile sulla base di un identificatico. La nuova variabile verrÃ  chiamata 'id'
prov <- gUnaryUnion(shape, id = shape@data$COD_PRO)

# Converto il nuovo shapefile in un dataframe
prov_df <- fortify(prov)

ggplot() +
  theme_void() +
  geom_polygon(prov_df, mapping = aes(x=long, y=lat, group=group, fill=id), color='black') +
  coord_equal()


#raster::shapefile(x = regioni, 'test_regioni.shp')
#shape <- readOGR('test_regioni.shp')

#-----------------------------------------------------------------------------------------------------#
# Dissolve con la funzione raster::aggregate
#-----------------------------------------------------------------------------------------------------#
library(rgdal)
library(raster)
#library(maptools)
library(tidyr)
library(broom)
library(ggplot2)

shape <- readOGR("Com2016_WGS84_g")

shape_new <- raster::aggregate(shape, "COD_REG") # verificare se funziona senza rgeos
#shape_new_df <- fortify(shape_new)
#shape_new_df <- broom::tidy(shape_new) # 2.

ggplot() +
  theme_void() +
  geom_polygon(shape_new, mapping = aes(x=long, y=lat, group=group, fill=id), color='black') +
  #geom_polygon(shape_new_df, mapping = aes(x=long, y=lat, group=group, fill=id), color='black') + # 2.
  coord_equal()

# Salvo il nuovo shapefile
#raster::shapefile(shape_new, 'shape_new2.shp')

