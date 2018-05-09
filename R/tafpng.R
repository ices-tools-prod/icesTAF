#' PNG Device
#'
#' Open PNG graphics device to create an image file inside the TAF \verb{report}
#' folder.
#'
#' @param filename image filename.
#' @param width image width (pixels).
#' @param height image height (pixels).
#' @param pointsize text size.
#' @param \dots passed to \code{png}.
#'
#' @details
#' The \code{filename} can be passed without the preceding
#' \verb{report/}, and without the \verb{.png} filename extension.
#'
#' Specifically, the function prepends \verb{"report/"} to the filename if (1)
#' the filename does not contain a \verb{"/"} separator, (2) the working
#' directory is not \verb{"report"}, and (3) the directory \verb{"report"}
#' exists. The function appends \verb{".png"} to the filename if it does not
#' already have that filename extension.
#'
#' This automatic filename manipulation can be bypassed by using the \code{png}
#' function directly.
#'
#' @note
#' A simple convenience function to shorten
#' \preformatted{png("report/myplot.png", width=800, height=600, pointsize=22)}
#' to
#' \preformatted{tafpng("myplot")}
#'
#' @seealso
#' \code{\link{png}} is the underlying function used to open a PNG graphics
#' device.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' tafpng("myplot")
#' plot(1)
#' dev.off()
#' }
#'
#' @importFrom grDevices png
#'
#' @export

tafpng <- function(filename, width=800, height=600, pointsize=22, ...)
{
  if(!grepl("/",filename) && !grepl("report$",getwd()) && dir.exists("report"))
    filename <- paste0("report/", filename)
  if(!grepl("\\.png$", filename))
    filename <- paste0(filename, ".png")
  png(filename=filename, width=width, height=height, pointsize=pointsize, ...)
}
