#' Scan a project or folder for packages used
#'
#' @inheritParams cite_packages
#' @param ... Other parameters passed to [renv::dependencies()].
#'
#' @return a data.frame with package names and versions
#' @export
#'
#' @examplesIf interactive()
#' scan_packages()
#' scan_packages(pkgs = "Session")
#' scan_packages(pkgs = c("renv", "remotes", "knitr"))


scan_packages <- function(pkgs = "All",
                          omit = c("grateful"),
                          cite.tidyverse = TRUE,
                          dependencies = FALSE,
                          ...) {

  stopifnot(is.character(pkgs))
  stopifnot(is.null(omit) | is.character(omit))
  stopifnot(is.logical(cite.tidyverse))
  stopifnot(is.logical(dependencies))

  # If pkgs != "All" nor "Session", use them directly as vector of pkg names
  pkgnames <- pkgs

  if (length(pkgs) == 1 && pkgs == "All") {
    pkgnames <- unique(renv::dependencies(progress = FALSE, ...)$Package)
    pkgnames <- pkgnames[pkgnames != "R"]
  }

  if (length(pkgs) == 1 && pkgs == "Session") {
    pkgnames <- names(utils::sessionInfo()$otherPkgs)
  }



  # Include recursive dependencies?
  if (isTRUE(dependencies)) {
    pkgnames <- remotes::package_deps(pkgnames)$package
  }


  # Collapse tidyverse packages into single citation?
  # tidy.pkgs list provided in 'tidyverse.R'
  if (cite.tidyverse && any(pkgnames %in% tidy.pkgs)) {
    pkgnames <- pkgnames[!pkgnames %in% tidy.pkgs]
    pkgnames <- pkgnames[pkgnames != "tidyverse"]
    pkgnames <- c(pkgnames, "tidyverse")
  }


  # If scanning pkgs (ie. not using provided pkg names):
  if (length(pkgs) == 1) {
    if (pkgs == "All" | pkgs == "Session") {

      # Only cite base R once
      base_pkgs <- utils::sessionInfo()$basePkgs
      pkgnames <- c("base", setdiff(pkgnames, base_pkgs))

      # Omit packages
      if (!is.null(omit)) {
        stopifnot(is.character(omit))  # omit must be a character vector of pkg names
        pkgnames <- pkgnames[!pkgnames %in% omit]
      }
    }
  }


  # Important to sort pkgnames to match versions later
  pkgnames <- sort(pkgnames)


  ## Get package versions

  # Some people may not have the 'tidyverse' package installed locally
  # First, get versions for all packages except 'tidyverse'
  pkgs.notidy <- pkgnames[pkgnames != "tidyverse"]
  versions <- pkgVersion(pkgs.notidy)
  versions <- unlist(lapply(versions, as.character))

  # Then add 'tidyverse' version
  # If not installed, assume version "2.0.0" (last in CRAN)
  if ("tidyverse" %in% pkgnames) {
    tidy.version <- tryCatch(as.character(utils::packageVersion("tidyverse")),
                             error = function(e) {'2.0.0'})
    names(tidy.version) <- "tidyverse"
    versions <- c(versions, tidy.version)
    versions <- versions[sort(names(versions))]
  }

  pkgs.df <- data.frame(pkg = pkgnames, version = versions, row.names = NULL)

  pkgs.df

}


pkgVersion <- Vectorize(utils::packageVersion, SIMPLIFY = FALSE)
