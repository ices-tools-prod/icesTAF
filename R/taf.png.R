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
#' \preformatted{png("report/plot.png", width=1600, height=1200, pointsize=32)}
#' to
#' \preformatted{taf.png("plot")}
#'
#' The \code{pointsize} argument only affects base plots. To change the text
#' size of a lattice plot, the \code{zoom} function can be helpful.
#'
#' For consistent image width and text size, it can be useful to keep the
#' default \code{width = 1600} but vary the \code{height} to get the desired
#' aspect ratio for each plot.
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
#' qplot(1, 1)
#' dev.off()
#' }
#'
#' @aliases tafpng
#'
#' @importFrom grDevices png
#'
#' @export

taf.png <- function(filename, width=1600, height=1200, pointsize=32, ...)
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
