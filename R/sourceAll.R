#' Run TAF Scripts in Alphabetical Order
#'
#' Run all TAF scripts in a directory, in alphabetical order. Optionally, start
#' by cleaning old output directories and emptying the workspace before running
#' each script.
#'
#' @param path directory containing TAF scripts.
#' @param rm whether to remove all objects from the global environment before
#'        each script is run.
#' @param clean whether to \code{\link{clean}} existing TAF directories before
#'        running the scripts.
#' @param quiet whether to suppress messages reporting progress.
#'
#' @details
#' By default, TAF scripts are run with \code{rm = TRUE} to make sure each
#' script starts with an empty workspace. Likewise, the default
#' \code{clean = TRUE} makes sure that the scripts start by creating new empty
#' directories and populate them one by one.
#'
#' @return
#' Logical vector, indicating which scripts ran without errors.
#'
#' @seealso
#' \code{\link{sourceTAF}} runs a TAF script.
#'
#' \code{\link{make}} runs a TAF script if needed.
#'
#' \code{\link{clean}} cleans TAF directories.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' sourceAll()
#' }
#'
#' @export

sourceAll <- function(path=".", rm=TRUE, clean=TRUE, quiet=FALSE)
{
  if(clean)
    clean(path)

  scripts <- dir(path, pattern="\\.[Rr]$")

  ok <- sapply(scripts, function(x) sourceTAF(x, rm=rm, quiet=quiet))
  if(length(ok) == 0)
    ok <- logical(0)

  invisible(ok)
}
