#' Read DLS Advice from File
#'
#' Read the advisory calculations for a data-limited stock (DLS) from a file.
#'
#' @param file a filename.
#'
#' @return
#' A list containing \code{advice} and other elements showing intermediate steps
#' in the calculations.
#'
#' @seealso
#' \code{\link{writeDLS}} writes DLS advisory calculations to a file.
#'
#' \code{\link[icesAdvice]{DLS3.2}} in the \pkg{icesAdvice} package can be used
#' to calculate catch advice for data-limited stocks.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' library(icesAdvice)
#' survey <- data.frame(year=2001:2010, randu[1:10,])
#' dls <- DLS3.2(1000, survey$y)
#' writeDLS(dls, "dls-output.txt")
#' dls2 <- readDLS("dls-output.txt")
#' }
#' @export

readDLS <- function(file)
{
  x <- readLines(file)
  x <- x[x != ""]
  out <- list()
  while(length(x) > 0)
  {
    value <- strsplit(x[2], " ")[[1]]
    if(value[1] %in% c("TRUE","FALSE"))
      value <- as.logical(value)
    if(substring(value[1],1,1) %in% 0:9)
      value <- as.numeric(value)
    out[[x[1]]] <- value
    x <- x[-(1:2)]
  }
  out
}
