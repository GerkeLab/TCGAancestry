library(hexSticker)

# Icons made by "https://www.flaticon.com/authors/freepik" from 
# https://www.flaticon.com/ 

# make plot -------------------------------------------------------------------
## based on : https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html

library("ggplot2")
library("sf")
library("rnaturalearth")
library("rnaturalearthdata")

theme_set(theme_void())
world <- ne_countries(scale = "medium", returnclass = "sf")

world_map <- ggplot(data = world) + 
  geom_sf(color = "black", fill = "#FF33B5", size = 0.1) + 
  coord_sf(crs = "+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ")
  

# sticker ---------------------------------------------------------------------

sysfonts::font_add_google("Fjalla One")

sticker(world_map, package="TCGAancestry",
        p_size=6, p_color = "#FF6E33", p_family="Fjalla One", p_y = 1,
        s_x=1, s_y=1, s_width=1.7, s_height=1.7,
        h_fill="white", h_color="#FF6E33", 
        url = "www.gerkelab.com", u_color = "#FF6E33", u_size = 1.3,
        filename="Documents/github/TCGAancestry/man/ancestry_hex.png")