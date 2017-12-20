#' Run R Script If Needed
#'
#' Run an R script if underlying data files have changed, otherwise do nothing.
#'
#' @param recipe script filename.
#' @param prereq one or more underlying data files, required by the script.
#' @param target one output file, produced by the script.
#' @param include whether to automatically include the script as a prerequisite
#'        file.
#' @param engine function to source the script.
#' @param debug whether to show a diagnostic table of files and time last
#'        modified.
#' @param \dots passed to \code{engine}.
#'
#' @return \code{TRUE} or \code{FALSE}, indicating whether the script was run.
#'
#' @seealso
#' \code{\link{source}} runs an R script.
#'
#' \code{\link{makeTAF}} runs a TAF script if needed.
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
    print(data.frame(Object=c("target",rep("prereq",length(prereq))),
                     File=c(target,prereq),
                     Modified=file.mtime(c(target,prereq))))
  if(!all(file.exists(prereq)))
    stop("missing prerequisite file '", prereq[!file.exists(prereq)][1], "'")
  if(!file.exists(target) || file.mtime(target) < max(file.mtime(prereq)))
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
