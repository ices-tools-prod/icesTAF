#' Run TAF Scripts in Alphabetical Order
#'
#' Run all TAF scripts in a directory, except \file{all.R}. Scripts are run
#' sequentially, in alphabetical order. Optionally, start by cleaning old output
#' directories and emptying the workspace before running each script.
#'
#' @param path directory containing TAF scripts.
#' @param rm whether to remove all objects from the global environment, before
#'        each script is run.
#' @param clean whether to remove directories \file{db}, \file{input},
#'        \file{model}, \file{output}, and \file{report}.
#' @param quiet whether to suppress messages reporting progress.
#'
#' @details
#' TAF scripts should be run with \code{rm = TRUE} to make sure each script
#' starts with an empty workspace. The default \code{rm = FALSE} is mainly to
#' prevent accidental loss of work by users not familiar with the function.
#'
#' Use \code{clean = TRUE} to make sure the scripts start by creating new empty
#' directories and populate them one by one. Again, the default
#' \code{clean = FALSE} is mainly to prevent accidental loss of work by users
#' not familiar with the function.
#'
#' @return
#' Logical vector, indicating which scripts ran without errors.
#'
#' @note
#' The \code{sourceAtoZ} function ignores \file{all.R} if such a script exists.
#' The reason for this is that many TAF assessments have a script called
#' \file{all.R} that runs all (or selected) scripts in alphabetical order.
#' Running \file{all.R} and then running all other scripts would effectively
#' repeat the entire assessment procedure twice.
#'
#' @seealso
#' \code{\link{sourceTAF}} runs a TAF script.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' sourceAtoZ()
#' }
#'
#' @export

sourceAtoZ <- function(path=".", rm=FALSE, clean=FALSE, quiet=FALSE)
{
  if(clean)
    unlink(c("db","input","model","output","upload"), recursive=TRUE)

  scripts <- dir(path, pattern="\\.[Rr]$")
  scripts <- grep("^all\\.[Rr]", scripts, invert=TRUE, value=TRUE)

  ok <- sapply(scripts, function(x) sourceTAF(x, rm=rm, quiet=quiet))
  if(length(ok) == 0)
    ok <- logical(0)

  invisible(ok)
}
