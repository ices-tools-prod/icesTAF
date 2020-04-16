#' Detach Packages
#'
#' Detach all non-base packages that have been attached using \code{library} or
#' \code{taf.library}.
#'
#' @param quiet whether to suppress messages.
#'
#' @seealso
#' \code{\link{detach}} is the underlying base function to detach a package.
#'
#' \code{\link{taf.library}} loads a package from \verb{bootstrap/library}.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' detach.packages()
#' }
#'
#' @export

detach.packages <- function(quiet=FALSE)
{
  pkgs <- sessionInfo()$otherPkgs
  if(!is.null(pkgs))
  {
    pkgs <- names(pkgs)
    sapply(paste0("package:",pkgs), detach, character.only=TRUE)
    invisible(pkgs)
    if(!quiet)
      message(paste(c("Detached packages:",pkgs), collapse="\n  "))
  }
  else if(!quiet)
  {
    message("Only base packages attached - nothing to be detached.")
  }
  invisible(pkgs)
}
