#' List Dependencies
#'
#' Search R scripts for packages that are required.
#'
#' @param path a directory or file containing R scripts.
#' @param base whether to include base packages in the output.
#' @param installed whether to include installed packages in the output.
#' @param available whether to include available packages in the output.
#' @param list whether to return packages in list format.
#'
#' @return
#' Names of packages as a vector, or in list format if \code{list=TRUE}. If no
#' dependencies are found, the return value is \code{NULL}.
#'
#' @note
#' Package names are matched based on four patterns:\preformatted{
#' library(*)
#' require(*)
#' *::object
#' *:::object}
#'
#' The search algorithm may return false-positive dependencies if these patterns
#' occur inside if-clauses, strings, comments, etc.
#'
#' @seealso
#' \code{\link{installed.packages}}, \code{\link{available.packages}}.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' dir <- system.file(package="MASS", "scripts")
#' script <- system.file(package="MASS", "scripts/ch08.R")
#'
#' deps(script)                   # dependencies
#' deps(script, base=TRUE)        # including base packages
#' deps(script, installed=FALSE)  # not (yet) installed
#'
#' deps(dir)
#' deps(dir, list=TRUE)
#'
#' \dontrun{
#' deps(dir, available=FALSE)  # dependencies that might be unavailable
#' }
#'
#' @importFrom utils available.packages installed.packages
#'
#' @export

deps <- function(path=".", base=FALSE, installed=TRUE, available=TRUE,
                 list=FALSE)
{
  files <- if(dir.exists(path)) dir(path, pattern="\\.[Rr]$", full.names=TRUE)
           else path
  code <- lapply(files, readLines)
  names(code) <- basename(files)

  ## Look for loaded packages and pkg::object calls
  pattern <- ".*(library|require)\\(\"?'? *([A-Za-z0-9.]+).*"
  p.load <- lapply(code, grep, pattern=pattern, value=TRUE)
  p.load <- gsub(pattern, "\\2", unlist(p.load))
  pattern <- ".*?([A-Za-z0-9.]+):::?[A-Za-z].*"
  p.obj <- lapply(code, grep, pattern=pattern, value=TRUE)
  p.obj <- gsub(pattern, "\\1", unlist(p.obj))

  ## Combine all packages, maybe exclude base/installed/available
  pkgs <- c(p.load, p.obj)
  if(!base)
    pkgs <- pkgs[!(pkgs %in% rownames(installed.packages(priority="high")))]
  if(!installed)
    pkgs <- pkgs[!(pkgs %in% rownames(installed.packages()))]
  if(!available)
    pkgs <- pkgs[!(pkgs %in% rownames(available.packages()))]

  ## Format output
  names(pkgs) <- sub("[0-9]*$", "", names(pkgs))
  pkgs <- sort(pkgs)
  pkgs <- if(list) split(unname(pkgs), names(pkgs)) else unique(unname(pkgs))
  pkgs <- if(length(unlist(pkgs)) == 0) NULL else pkgs
  pkgs
}
