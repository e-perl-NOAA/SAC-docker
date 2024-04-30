# Install R packages for hake assessment docker image

install.packages(c("remotes","purrr"))
library(remotes)
library(purrr)

# These are the packages on GitHub, in alphabetical order
github_pac_lst <- c("r4ss/r4ss",
                    "ss3sim/ss3sim",
                    "PIFSCstockassessments/ss3diags",
                    "chantelwetzel-noaa/HandyCode",
                    "nwfsc-assess/nwfscDiag")

walk(github_pac_lst, \(pkg){
  install_github(pkg)
})

# These are packages on CRAN. Alphabetical order, each line has the same
# starting letter for each package (new line for new starting letter)
pac_lst <- c(
  "corrplot","cowplot","data.tree","date","furrr","glue","grDevices","grid","gridGraphics", 
  "gtable","knitr","magick","RColorBrewer","readr","scales","sf","tidyverse","tidyselect", 
  "tictoc","utils","with","devtools","shiny","shinyjs","ggplot2","reshape2","dplyr","tidyr",
  "Rcpp","rlist","viridis","shinyWidgets","shinyFiles","plyr","shinybusy",
  "truncnorm","ggpubr","flextable","officer","gridExtra","wesanderson","data.table",
  "adnuts","shinystan","shinyBS","gt","gtExtras","stringr","ggnewscale","msm",
  "EnvStats","tmvtnorm","future","parallel","parallelly","fs","tools")

install.packages(pac_lst)
