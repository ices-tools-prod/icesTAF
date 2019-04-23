#' Zoom
#'
#' Change text size in a lattice plot.
#'
#' @param x a lattice plot of class \code{"trellis"}.
#' @param size text size multiplier.
#' @param main size of main title (default is \code{1.2 * size}).
#' @param lab size of axis labels (default is \code{size}).
#' @param axis size of tick labels (default is \code{size}).
#' @param strip size of strip labels (default is \code{size}).
#' @param symbol size of text inside plot (default is \code{size}).
#' @param sub size of subtitle (default is \code{0.9 * size}).
#' @param legend size of legend labels (default is \code{0.9 * size}).
#' @param \dots further arguments, currently ignored.
#'
#' @return The same lattice object, but with altered text size.
#'
#' @note
#' The default values result in lattice plots that have similar text size as
#' base plots, when using \code{taf.png}.
#'
#' This function ends with a \code{\link[=print.trellis]{print}} call, to make
#' it easy to export the lattice plot to a file, without the need of an explicit
#' \code{print}.
#'
#' @seealso
#' \code{\link{Lattice}} plots are created using \code{\link{xyplot}} or related
#' functions.
#'
#' \code{\link{taf.png}} opens a PNG graphics device.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' library(lattice)
#'
#' xyplot(1~1)
#' zoom(xyplot(1~1))
#' zoom(xyplot(1~1), size=1, axis=0.8)
#'
#' \dontrun{
#' taf.png("myplot")
#' plot(1)
#' dev.off()
#'
#' taf.png("mytrellis")
#' zoom(xyplot(1~1))
#' dev.off()
#'}
#'
#' @export

zoom <- function(x, ...)
{
  UseMethod("zoom")
}

#' @rdname zoom
#' @export
#' @export zoom.trellis

zoom.trellis <- function(x, size=2.7, main=1.2*size, lab=size, axis=size,
                         strip=size, symbol=size, sub=0.9*size, legend=0.9*size,
                         ...)
{
  suppressWarnings({
    x$main$cex <- main
    x$xlab$cex <- lab
    x$ylab$cex <- lab
    x$x.scales$cex <- rep(axis, length(x$x.scales$cex))
    x$y.scales$cex <- rep(axis, length(x$y.scales$cex))
    x$par.strip.text$cex <- strip
    x$par.settings$superpose.symbol$cex <- symbol
    x$sub$cex <- sub
    if(!is.null(x$legend))
      x$legend$right$args$cex <- legend
  })
  print(x)
}
