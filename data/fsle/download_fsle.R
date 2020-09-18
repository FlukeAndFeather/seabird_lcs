# https://gist.github.com/raymondben/6a00ccc14b27dfe441dc1c071ad3baf3
# remotes::install_github("AustralianAntarcticDivision/blueant")
library(blueant)
library(tidyverse)

data_dir <- "data/fsle/" ## destination dir, change as needed
#dir.create(data_dir) ## must exist

## "FSLE NRT" for near-real-time, "FSLE DT" for delayed-time
src <- sources("FSLE DT") %>% 
  bb_modify_source(
    user = "maxczap@stanford.edu", 
    password = rstudioapi::askForPassword("Aviso password"),
    method = list(accept_follow = "/(2015)")
  )
result <- bb_get(src, local_file_root = data_dir, verbose = TRUE)

# I think that worked? Let's try making a map
library(ncdf4)
library(raster)
fsle_nc <- nc_open("data/fsle/ftp-access.aviso.altimetry.fr/value-added/lyapunov/delayed-time/global/2015/dt_global_allsat_madt_fsle_20150102_20180704.nc")
fsle_val <- ncvar_get(fsle_nc, "fsle_max")
fsle_lon <- ncvar_get(fsle_nc, "lon")
fsle_lat <- ncvar_get(fsle_nc, "lat")
image(fsle_lon, fsle_lat, fsle_val, useRaster = TRUE)

fsle_rst <- raster("data/fsle/ftp-access.aviso.altimetry.fr/value-added/lyapunov/delayed-time/global/2015/dt_global_allsat_madt_fsle_20150102_20180704.nc", varname = "fsle_max")
summary(fsle_rst)
natl_bbox <- as(extent(360 - 75, 360 - 0.001, 15, 50), "SpatialPolygons")
crs(natl_bbox) <- crs(fsle_rst)
natl_fsle <- crop(fsle_rst, natl_bbox)
q_breaks <- quantile(values(natl_fsle), 
                     seq(0, 1, length.out = 25), 
                     na.rm = TRUE) %>% 
  unique()
plot(natl_fsle, 
     breaks = q_breaks,
     col = hcl.colors(length(q_breaks), "purples"),
     colNA = "#000000")
