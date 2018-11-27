#' @docType package
#'
#' @name icesTAF-package
#'
#' @aliases icesTAF
#'
#' @title Functions to Support the ICES Transparent Assessment Framework
#'
#' @description
#' Functions to support the ICES Transparent Assessment Framework, to organize
#' data, methods, and results used in ICES assessments.
#'
#' @details
#' \emph{Web services:}
#' \tabular{ll}{
#'   \code{\link{download}} \tab download file in binary mode
#' }
#' \emph{Read and write files:}
#' \tabular{ll}{
#'   \code{\link{read.taf}}  \tab read TAF table from file\cr
#'   \code{\link{write.taf}} \tab write TAF table to file
#' }
#' \emph{Run scripts:}
#' \tabular{ll}{
#'   \code{\link{make}}      \tab run R script if needed\cr
#'   \code{\link{makeAll}}   \tab run all TAF scripts as needed\cr
#'   \code{\link{makeTAF}}   \tab run TAF script if needed\cr
#'   \code{\link{msg}}       \tab show message\cr
#'   \code{\link{sourceAll}} \tab run all TAF scripts\cr
#'   \code{\link{sourceTAF}} \tab run TAF script
#' }
#' \emph{Other file management:}
#' \tabular{ll}{
#'   \code{\link{clean}}        \tab clean TAF directories\cr
#'   \code{\link{cp}}           \tab copy files\cr
#'   \code{\link{dos2unix}}     \tab convert line endings\cr
#'   \code{\link{mkdir}}        \tab create directory\cr
#'   \code{\link{rmdir}}        \tab remove directory\cr
#'   \code{\link{taf.library}}  \tab enable TAF library\cr
#'   \code{\link{taf.skeleton}} \tab create empty TAF template\cr
#'   \code{\link{taf.unzip}}    \tab unzip file\cr
#'   \code{\link{unix2dos}}     \tab convert line endings
#' }
#' \emph{Table tools:}
#' \tabular{ll}{
#'   \code{\link{div}}      \tab divide column values\cr
#'   \code{\link{flr2taf}}  \tab convert FLR to TAF\cr
#'   \code{\link{long2taf}} \tab convert long format to TAF\cr
#'   \code{\link{plus}}     \tab rename plus group column\cr
#'   \code{\link{rnd}}      \tab round column values\cr
#'   \code{\link{taf2long}} \tab convert TAF to long format\cr
#'   \code{\link{taf2xtab}} \tab convert TAF to crosstab\cr
#'   \code{\link{tt}}       \tab transpose TAF table\cr
#'   \code{\link{xtab2taf}} \tab convert crosstab to TAF
#' }
#' \emph{Plotting tools:}
#' \tabular{ll}{
#'   \code{\link{lim}}        \tab compute axis limits\cr
#'   \code{\link{taf.colors}} \tab predefined colors\cr
#'   \code{\link{tafpng}}     \tab open PNG graphics device
#' }
#' \emph{Example tables:}
#' \tabular{ll}{
#'   \code{\link{catage.long}} \tab long format\cr
#'   \code{\link{catage.taf}}  \tab TAF format\cr
#'   \code{\link{catage.xtab}} \tab crosstab format\cr
#'   \code{\link{summary.taf}} \tab summary results
#' }
#' \emph{Administrative tools:}
#' \tabular{ll}{
#'   \code{\link{deps}}       \tab list dependencies\cr
#'   \code{\link{os.unix}}    \tab OS family\cr
#'   \code{\link{os.windows}} \tab OS family
#' }
#'
#' @author Arni Magnusson and Colin Millar.
#'
#' @references
#' ICES Transparent Assessment Framework: \url{http://taf.ices.dk}.
#'
#' To explore example TAF stock assessments, see the introductory
#' \href{https://www.youtube.com/watch?v=FweJbr9hfdY}{video} and
#' \href{https://github.com/ices-taf/doc/tree/master/tutorial-1/README.md}{tutorial}.

NA
