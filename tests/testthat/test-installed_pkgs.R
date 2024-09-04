# test_that("installed packages get proper citation", {
#
#   skip_on_cran()
#   skip_on_ci()
#   skip_on_covr()
#
#   library(grateful)
#   library(renv)
#   cite_packages(out.dir = ".")
#   cite_packages(out.dir = ".", pkgs = "Session")
#   cite_packages(out.dir = ".", pkgs = "Session", passive.voice = TRUE)
#   cite_packages(out.dir = ".", pkgs = c("base", "renv", "grateful"), passive.voice = TRUE)
#   cite_packages(out.dir = ".", pkgs = "grateful", dependencies = TRUE, passive.voice = TRUE)
#
#   pkgs <- installed.packages()[, "Package"]
#
#   info <- get_pkgs_info(pkgs, out.dir = ".", cite.tidyverse = FALSE)
#
#   stopifnot(nrow(info) == length(pkgs))
#   unname(pkgs[which(! pkgs %in% info$pkg)])
#
#   tabla <- cite_packages(output = "table", out.dir = ".", pkgs = pkgs,
#                          include.RStudio = FALSE, cite.tidyverse = FALSE)
#   stopifnot(nrow(tabla) == length(pkgs))
#
#   ### slow ###
#   tabla <- cite_packages(output = "table", out.dir = ".", pkgs = pkgs,
#                          include.RStudio = FALSE, cite.tidyverse = FALSE, dependencies = TRUE)
#   unname(pkgs[which(! pkgs %in% tabla$Package)])  # base packages missing when dependencies = TRUE
#   ###
#
#   cite_packages(out.dir = ".", pkgs = pkgs, include.RStudio = TRUE)
#   cite_packages(out.dir = ".", pkgs = pkgs, include.RStudio = TRUE, passive.voice = TRUE)
#   # slow
#   # cite_packages(out.dir = ".", pkgs = pkgs, include.RStudio = TRUE,
#   #               cite.tidyverse = FALSE, passive.voice = TRUE, dependencies = TRUE)
#
#
#   cite_packages(output = "citekeys", out.dir = ".",
#                 pkgs = c("renv", "remotes", "dplyr", "ggplot2", "knitr"),
#                 include.RStudio = TRUE)
#
#   cite_packages(output = "table", out.dir = ".",
#                 pkgs = c("renv", "remotes", "dplyr", "ggplot2", "knitr"),
#                 include.RStudio = TRUE)
#
#   cite_packages(output = "paragraph", out.dir = ".",
#                 pkgs = c("renv", "remotes", "dplyr", "ggplot2", "knitr"),
#                 include.RStudio = TRUE)
#
#   cite_packages(output = "paragraph", out.dir = ".",
#                 pkgs = c("renv", "remotes", "dplyr", "ggplot2", "knitr", "base"),
#                 include.RStudio = TRUE, passive.voice = TRUE)
#
#
# })
#
