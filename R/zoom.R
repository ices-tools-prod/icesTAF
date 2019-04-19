#' Zoom
#'
#' Change text size in a lattice plot.
#'
#' @param obj a lattice plot of class \code{"trellis"}.
#' @param cex text size multiplier.
#' @param cex.main size of main title (default is \code{2.7 * cex}).
#' @param cex.lab size of axis labels (default is \code{1.2 * cex}).
#' @param cex.axis size of tick labels (default is \code{cex}).
#' @param cex.strip size of strip labels (default is \code{cex}).
#' @param cex.symbol size of text inside plot (default is \code{cex}).
#' @param cex.sub size of subtitle (default is \code{0.9 * cex}).
#' @param cex.legend size of legend labels (default is \code{0.9 * cex}).
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
#' zoom(xyplot(1~1), cex=1, cex.axis=0.8)
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

zoom <- function(obj, cex=2.7, cex.main=1.2*cex, cex.lab=cex, cex.axis=cex,
                 cex.strip=cex, cex.symbol=cex, cex.sub=0.9*cex,
                 cex.legend=0.9*cex)
{
  suppressWarnings({
    if(class(obj) != "trellis")
      stop("'obj' must be a trellis object")
    obj$main$cex <- cex.main
    obj$xlab$cex <- cex.lab
    obj$ylab$cex <- cex.lab
    obj$x.scales$cex <- rep(cex.axis, length(obj$x.scales$cex))
    obj$y.scales$cex <- rep(cex.axis, length(obj$y.scales$cex))
    obj$par.strip.text$cex <- cex.strip
    obj$par.settings$superpose.symbol$cex <- cex.symbol
    obj$sub$cex <- cex.sub
    if(!is.null(obj$legend))
      obj$legend$right$args$cex <- cex.legend
  })
  print(obj)
}
