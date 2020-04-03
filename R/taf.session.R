#' TAF Session
#'
#' Show session information about loaded packages, clearly indicating which
#' packages were loaded from the local TAF library.
#'
#' @param sort whether to sort packages by name.
#'
#' @return
#' Data from containing four columns:
#' \item{Package}{package name}
#' \item{Version}{package version}
#' \item{Library}{library where package was loaded from}
#' \item{RemoteSha}{GitHub reference code}
#'
#' @seealso
#' \code{\link{sessionInfo}} and the \pkg{sessioninfo} package provide further
#' session information about the version of R, etc.
#'
#' \code{\link{taf.libPaths}} adds the TAF library to the search path for R
#' packages.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \donttest{
#' taf.session()
#' taf.session(TRUE)
#' }
#'
#' @importFrom utils sessionInfo
#' @importFrom stats setNames
#'
#' @export

taf.session <- function(sort=FALSE)
{
  info <- function(desc)
  {
    lib <- dirname(find.package(desc$Package))
    desc$Library <- if(basename(dirname(lib)) == "bootstrap")
                      "TAF" else paste0("[", match(lib, .libPaths()), "]")
    desc$RemoteSha <- if(is.null(desc$RemoteSha))
                        "" else substring(desc$RemoteSha, 1, 7)
    fields <- c("Package", "Version", "Library", "RemoteSha")
    if(identical(desc$Priority, "base"))
      setNames(rep(NA_character_, 4), fields)
    else
      unlist(desc[fields])
  }

  si <- sessionInfo()

  pkgs <- sapply(c(si$otherPkgs, si$loadedOnly), info)
  pkgs <- pkgs[,apply(pkgs, 2, function(x) !all(is.na(x)))]
  pkgs <- data.frame(t(pkgs), row.names=NULL)
  if(sort)
    pkgs <- data.frame(pkgs[order(pkgs$Package),], row.names=NULL)

  pkgs
}
