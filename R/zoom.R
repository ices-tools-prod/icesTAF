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
#' @param sub size of subtitle (default is \code{0.9 * size}).
#' @param legend size of legend labels (default is \code{0.9 * size}).
#' @param splom size of scatterplot matrix diagonal labels (default is
#'        \code{0.9 * size}).
#' @param \dots further arguments, currently ignored.
#'
#' @details
#' Pass \code{NULL} for any argument to avoid changing the size of that text
#' component.
#'
#' The \code{legend} component of a lattice plot can be somewhat fickle, as the
#' object structure varies between plots. One solution is to pass
#' \code{legend = NULL} and tweak the legend before or after calling the
#' \code{zoom} function.
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
#' zoom(xyplot(1~1), lab=NULL, axis=NULL)
#'
#' \dontrun{
#' taf.png("myplot")
#' plot(1)
#' dev.off()
#'
#' taf.png("mytrellis")
#' zoom(xyplot(1~1))
#' dev.off()
#' }
#'
#' @export

zoom <- function(x, ...)
{
  UseMethod("zoom")
}

#' @rdname zoom
#'
#' @importFrom lattice xyplot
#'
#' @export
#' @export zoom.trellis

zoom.trellis <- function(x, size=2.7, main=1.2*size, lab=size, axis=size,
                         strip=size, sub=0.9*size, legend=0.9*size,
                         splom=0.9*size, ...)
{
  suppressWarnings({
    if(!is.null(main)) x$main$cex <- main
    if(!is.null(lab)) x$xlab$cex <- lab
    if(!is.null(lab)) x$ylab$cex <- lab
    if(!is.null(axis)) x$x.scales$cex <- rep(axis, length(x$x.scales$cex))
    if(!is.null(axis)) x$y.scales$cex <- rep(axis, length(x$y.scales$cex))
    if(!is.null(strip)) x$par.strip.text$cex <- strip
    if(!is.null(sub)) x$sub$cex <- sub

    if(!is.null(legend) && !is.null(x$legend))
    {
      side <- names(x$legend)[1]
      x$legend[[side]]$args$key$cex.title <- legend
      ## Sometimes cex, key$cex, or key$text$cex ... just set them all
      x$legend[[side]]$args$cex <- legend
      x$legend[[side]]$args$key$cex <- legend
      x$legend[[side]]$args$key$text$cex <- legend
    }

    if(!is.null(splom)) x$panel.args.common$varname.cex <- splom
  })
  print(x)
}
