#' OS Family
#'
#' Determine whether operating system is Windows or Unix-compatible.
#'
#' @note
#' These shorthand functions can be useful when writing workaround solutions in
#' platform-independent scripts.
#'
#' @seealso
#' \code{\link{.Platform}} reports the \code{OS.type} family.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' os.unix()
#' os.windows()
#'
#' @export

os.unix <- function()
{
  .Platform$OS.type == "unix"
}
