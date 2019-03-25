#' PNG Device
#'
#' Open PNG graphics device to export a plot into the TAF \verb{report} folder.
#'
#' @param filename plot filename.
#' @param width image width.
#' @param height image height.
#' @param pointsize text size.
#' @param \dots passed to \code{png}.
#'
#' @details
#' The \code{filename} can be passed without the preceding
#' \code{"report/"}, and without the \code{".png"} filename extension.
#'
#' Specifically, the function prepends \code{"report/"} to the filename if (1)
#' the filename does not contain a \code{"/"} separator, (2) the working
#' directory is not \verb{report}, and (3) the directory \verb{report} exists.
#' The function also appends \verb{".png"} to the filename if it does not
#' already have that filename extension.
#'
#' This automatic filename manipulation can be bypassed by using the \code{png}
#' function directly.
#'
#' @note
#' A simple convenience function to shorten
#' \preformatted{png("report/myplot.png", width=800, height=600, pointsize=22)}
#' to
#' \preformatted{taf.png("myplot")}
#' To successfully export \verb{trellis} and \verb{ggplot} objects to image
#' files in scripts, these objects should be explicitly printed (see examples
#' below).
#'
#' The \code{pointsize} argument only affects base plots. To change the text
#' size of a lattice plot, the \code{zoom} function can be helpful.
#'
#' @seealso
#' \code{\link{png}} is the underlying function used to open a PNG graphics
#' device.
#'
#' \code{\link{zoom}} changes text size in a lattice plot.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' taf.png("myplot")
#' plot(1)
#' dev.off()
#'
#' library(lattice)
#' taf.png("mytrellis")
#' zoom(xyplot(1~1))
#' dev.off()
#'
#' library(ggplot2)
#' taf.png("myggplot")
#' print(qplot(1, 1))
#' dev.off()
#' }
#'
#' @aliases tafpng
#'
#' @importFrom grDevices png
#'
#' @export

taf.png <- function(filename, width=800, height=600, pointsize=22, ...)
{
  if(!grepl("/",filename) && !grepl("report$",getwd()) && dir.exists("report"))
    filename <- file.path("report", filename)
  if(!grepl("\\.png$", filename))
    filename <- paste0(filename, ".png")
  png(filename=filename, width=width, height=height, pointsize=pointsize, ...)
}

#' @export

tafpng <- function(...)
{
  ## .Deprecated("taf.png")
  taf.png(...)
}
