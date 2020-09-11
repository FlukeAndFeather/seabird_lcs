# https://gist.github.com/raymondben/6a00ccc14b27dfe441dc1c071ad3baf3
remotes::install_github("AustralianAntarcticDivision/blueant")
library(blueant)
library(tidyverse)

data_dir <- "data/ftle/" ## destination dir, change as needed
#dir.create(data_dir) ## must exist

## "FSLE NRT" for near-real-time, "FSLE DT" for delayed-time
src <- sources("FSLE DT") %>% 
  bb_modify_source(
    user = "maxczap@stanford.edu", 
    password = rstudioapi::askForPassword("Aviso password"),
    method = list(accept_follow = "/(2015)")
  )
result <- bb_get(src, local_file_root = data_dir, verbose = TRUE)
