#' Draft DATA.bib
#'
#' Create an initial draft version of a \file{DATA.bib} metadata file.
#'
#' @param originator who prepared the data, e.g. a working group acronym.
#' @param year year of the analysis when the data were used. The default is the
#'        current year.
#' @param title description of the data, including survey names or the like.
#' @param period first and last year that the data cover, separated by a simple
#'        dash, or a single number if the data cover only one year. If the data
#'        do not cover specific years, this metadata field can be suppressed
#'        using \code{period = FALSE}.
#' @param source where the data originate from. This can be a URL, filename, or
#'        the special value \code{"file"}.
#' @param file optional filename to save the draft metadata to a file.
#' @param data.dir directory containing data files.
#' @param data.files data filenames. The default is all files inside
#'        \code{data.dir}.
#' @param append whether to append metadata entries to an existing file.
#'
#' @details
#' Typical usage is to specify \code{originator}, while using the default values
#' for the other arguments. Most data files have the same originator, which can
#' be specified to facilitate completing the entries after creating the initial
#' draft.
#'
#' The special value \verb{source = "file"} is described in the
#' \code{\link{process.bib}} help page, along with other metadata information.
#'
#' The default value \code{file = ""} prints the initial draft in the console,
#' instead of writing it to a file. The output can then be pasted into a file to
#' edit further, without accidentally overwriting an existing metadata file.
#'
#' This function is intended to be called from the top directory of a TAF
#' analysis which contains a \file{bootstrap/initial/data} directory, as
#' reflected in the default value of \code{data.dir}.
#'
#' @return
#' Object of class \verb{Bibtex}.
#'
#' @note
#' After creating the initial draft, the user can complete the description of
#' each data file inside the \verb{title} field and look into each file to
#' specify the \verb{period} that the data cover.
#'
#' @seealso
#' \code{\link{draft.software}} creates an initial draft version of a
#' \file{SOFTWARE.bib} metadata file.
#'
#' \code{\link{process.bib}} reads and processes metadata entries. The help page
#' contains example metadata entries and commentary.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' # Print in console
#' draft.data("WGEF", 2015)
#'
#' # Export to file
#' draft.data("WGEF", 2015, file="bootstrap/DATA.bib")
#' }
#'
#' @export

draft.data <- function(originator=NULL, year=format(Sys.time(),"%Y"),
                       title=NULL, period=NULL, source="file", file="",
                       data.dir="bootstrap/initial/data",
                       data.files=dir(data.dir,recursive=TRUE), append=FALSE)
{
  if(length(data.files) == 0)
    stop("'data.files' is an empty vector")

  ## 1  Assemble metadata
  line1 <- paste0("@Misc{", data.files, ",")
  line2 <- paste0("  originator = {", originator, "},")
  line3 <- paste0("  year       = {", year, "},")
  line4 <- paste0("  title      = {", title, "},")
  line5 <- paste0("  period     = {", period, "},")
  line6 <- paste0("  source     = {", source, "},")
  line7 <- "}"
  line8 <- ""

  ## 2  Combine and format
  out <- data.frame(line1, line2, line3, line4, line5, line6, line7, line8)
  out <- c(t(out))
  if(isFALSE(period))
    out <- out[substr(out,3,8) != "period"]  # remove 'period' line if FALSE
  out <- out[-length(out)]  # remove empty line at end
  class(out) <- "Bibtex"

  ## 3  Export
  ## No write() when file="", to ensure quiet assignment x <- draft.data()
  if(file == "")
  {
    out
  }
  else
  {
    if(append)
      write("", file=file, append=TRUE)  # empty line separator
    write(out, file=file, append=append)
    invisible(out)
  }
}
