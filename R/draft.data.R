#' Draft DATA.bib
#'
#' Create an initial draft version of a \file{DATA.bib} metadata file.
#'
#' @param originator who prepared the data, e.g. a working group acronym.
#' @param year year of the analysis when the data were used. The default is the
#'        current year.
#' @param title description of the data, including survey names or the like.
#' @param period a string of the form \code{"1990-2000"}, indicating the first
#'        and last year that the data cover, separated by a simple dash.
#'        Alternatively, a single number if the data cover only one year. If the
#'        data do not cover specific years, this metadata field can be
#'        suppressed using \code{period = FALSE}.
#' @param source where the data are copied/downloaded from. This can be a URL,
#'        filename, or the special value \code{"file"}.
#' @param file optional filename to save the draft metadata to a file. The value
#'        \code{TRUE} can be used as shorthand for \code{"bootstrap/DATA.bib"}.
#' @param append whether to append metadata entries to an existing file.
#' @param data.files data files to consider. The default is all folders and
#'        files inside \verb{bootstrap/initial/data}.
#' @param data.scripts data scripts to consider. The default is all \verb{*.R}
#'        files in the \verb{bootstrap} folder.
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
#' @return
#' Object of class \verb{Bibtex}.
#'
#' @note
#' This function is intended to be called from the top directory of a TAF
#' analysis. It looks for data files inside \file{bootstrap/initial/data} and
#' data scripts inside \file{bootstrap}.
#'
#' After creating the initial draft, the user can complete the description of
#' each data entry inside the \verb{title} field and look into each file to
#' specify the \verb{period} that the data cover.
#'
#' @seealso
#' \code{\link{period}} pastes two years to form a \code{period} string.
#'
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
#' # or equivalently
#' draft.data("WGEF", 2015, file=TRUE)
#' }
#'
#' @export

draft.data <- function(originator=NULL, year=format(Sys.time(),"%Y"),
                       title=NULL, period=NULL, source=NULL, file="",
                       append=FALSE, data.files=dir("bootstrap/initial/data"),
                       data.scripts=dir("bootstrap",pattern="\\.R$"))
{
  data.scripts <- file_path_sans_ext(data.scripts)
  entries <- c(data.files, data.scripts)
  if(length(entries) == 0)
    stop("no data (bootstrap/initial/data/*) ",
         "or data scripts (bootstrap/*.R) found")
  if(is.null(source))
    source <- rep(c("file","script"),
                  c(length(data.files),length(data.scripts)))

  ## 1  Assemble metadata
  line1 <- paste0("@Misc{", entries, ",")
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
  if(identical(period, FALSE))
    out <- out[substr(out,3,8) != "period"]  # remove 'period' line if FALSE
  out <- out[-length(out)]  # remove empty line at end
  class(out) <- "Bibtex"

  ## 3  Export
  if(identical(file, TRUE))
    file <- "bootstrap/DATA.bib"
  if(identical(file, FALSE))
    file <- ""
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
