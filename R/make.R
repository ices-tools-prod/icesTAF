#' Run R Script If Needed
#'
#' Run an R script if underlying files have changed, otherwise do nothing.
#'
#' @param recipe script filename.
#' @param prereq one or more underlying files, required by the script. For
#'        example, data files and/or scripts.
#' @param target one or more output files, produced by the script. Directory
#'        names can also be used.
#' @param include whether to automatically include the script itself as a
#'        prerequisite file.
#' @param engine function to source the script.
#' @param debug whether to show a diagnostic table of files and time last
#'        modified.
#' @param \dots passed to \code{engine}.
#'
#' @return \code{TRUE} or \code{FALSE}, indicating whether the script was run.
#'
#' @note
#' This function provides functionality similar to makefile rules, to determine
#' whether a script should be (re)run or not.
#'
#' If any \code{target} is missing or older than any \code{prereq}, then the
#' script is run.
#'
#' @references
#' Stallman, R. M. \emph{et al.} An introduction to makefiles. Chapter 2 in the
#' \emph{\href{https://www.gnu.org/software/make/manual/make.pdf}{GNU Make
#' manual}}.
#'
#' @seealso
#' \code{\link{source}} runs any R script, \code{\link{sourceTAF}} is more
#' convenient for running a TAF script, and \code{\link{sourceAll}} runs all TAF
#' scripts.
#'
#' \code{\link{make}}, \code{\link{makeTAF}}, and \code{\link{makeAll}} are
#' similar to the \code{source} functions, except they avoid repeating tasks
#' that have already been run.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' make("model.R", "input/input.dat", "model/results.dat")
#' }
#'
#' @export

make <- function(recipe, prereq, target, include=TRUE, engine=source,
                 debug=FALSE, ...)
{
  if(include)
    prereq <- union(prereq, recipe)
  if(debug)
    print(data.frame(Object=c(rep("target",length(target)),
                              rep("prereq",length(prereq))),
                     File=c(target,prereq),
                     Modified=file.mtime(c(target,prereq))))
  if(!all(file.exists(prereq)))
    stop("missing prerequisite file '", prereq[!file.exists(prereq)][1], "'")
  if(!all(file.exists(target)) ||
     min(file.mtime(target)) < max(file.mtime(prereq)))
  {
    engine(recipe, ...)
    out <- TRUE
  }
  else
  {
    out <- FALSE
  }
  invisible(out)
}
