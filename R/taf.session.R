#' TAF Session
#'
#' Show session information about loaded packages, clearly indicating which
#' packages were loaded from the local TAF library.
#'
#' @param sort whether to sort packages by name.
#' @param details whether to include more detailed session information.
#'
#' @return List containing session information about loaded packages.
#'
#' @seealso
#' \code{\link{sessionInfo}} and the \pkg{sessioninfo} package provide similar
#' information, but do not indicate clearly packages that were loaded from the
#' local TAF library.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \donttest{
#' taf.session()
#' taf.session(sort=TRUE)
#' taf.session(details=TRUE)
#' }
#'
#' @importFrom utils sessionInfo
#' @importFrom stats setNames
#'
#' @export

taf.session <- function(sort=FALSE, details=FALSE)
{
  info <- function(desc)
  {
    lib <- dirname(find.package(desc$Package))
    desc$Library <- if(lib %in% .libPaths())
                      paste0("[", match(lib, .libPaths()), "]") else "TAF"
    desc$RemoteSha <- if(is.null(desc$RemoteSha))
                        "" else substring(desc$RemoteSha, 1, 7)
    desc$TAF <- if(basename(dirname(lib)) == "bootstrap") "*" else ""
    fields <- c("Package", "Version", "Library", "RemoteSha", "TAF")
    if(identical(desc$Priority, "base"))
      setNames(rep(NA_character_, 5), fields)
    else
      unlist(desc[fields])
  }

  si <- sessionInfo()

  version <- R.version$version.string
  date <- Sys.Date()
  packages <- sapply(c(si$otherPkgs, si$loadedOnly), info)
  packages <- packages[,apply(packages, 2, function(x) !all(is.na(x)))]
  packages <- data.frame(t(packages), row.names=NULL)
  if(sort)
    packages <- data.frame(packages[order(packages$Package),], row.names=NULL)
  libPaths <- data.frame(Entry=.libPaths())
  out <- list(version=version, date=date, packages=packages, libPaths=libPaths)

  if(details)
  {
    running <- sessionInfo()$running
    arch <- R.version$arch
    user <- Sys.info()[["user"]]
    stringsAsFactors <- getOption("stringsAsFactors")
    encoding <- unlist(l10n_info())
    locale <- unlist(strsplit(Sys.getlocale(), ";"))
    locale <- strsplit(locale, "=")
    locale <- data.frame(matrix(unlist(locale), ncol=2, byrow=TRUE,
                                dimnames=list(NULL,c("Variable","Value"))))
    out <- c(out, list(running=running, arch=arch, user=user,
                       encoding=encoding, locale=locale))
  }

  out
}
