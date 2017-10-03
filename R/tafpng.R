#' PNG Device
#'
#' Open PNG graphics device to create an image file inside the TAF \verb{report}
#' folder.
#'
#' @param filename image filename.
#' @param width image width.
#' @param height image height.
#' @param pointsize text size.
#' @param \dots passed to \code{png}.
#'
#' @details
#' The \code{filename} can be passed without the preceding
#' \verb{report/}, and without the \verb{.png} filename extension.
#'
#' @note
#' A simple convenience function to shorten
#' \preformatted{png("report/myplot.png", width=800, height=600, pointsize=24)}
#' to
#' \preformatted{tafpng("myplot")}
#'
#' @seealso
#' \code{\link{png}} is the underlying function used to open a PNG graphics
#' device.
#'
#' \code{\link{ido}} closes a graphics device.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' tafpng("myplot")
#' plot(1)
#' ido()
#' }
#'
#' @importFrom grDevices png
#'
#' @export

tafpng <- function(filename, width=800, height=600, pointsize=24, ...)
{
  if(!grepl("^report/", filename))
    filename <- paste0("report/", filename)
  if(!grepl("\\.png$", filename))
    filename <- paste0(filename, ".png")
  png(filename=filename, width=width, height=height, pointsize=pointsize, ...)
}
