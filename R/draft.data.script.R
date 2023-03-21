#' Draft or create a boot data script
#'
#' Create an \file{R} file to fetch data including adding metadata
#' via roxygen2 fields to the top of the file.
#'
#' @param name the name of the dataset and the file name that will be
#'        created.
#' @param title description of the data, including survey names or the like.
#' @param description a more involved description if required.
#' @param format the format of the data produced, e.g. "csv"
#' @param originator who prepared the data, e.g. a working group acronym.
#' @param year year of the analysis when the data were used. The default is the
#'        current year.
#' @param period a numeric vector of the form \code{c(1990, 2000)},
#'        indicating the first and last year that the data cover.
#'        Alternatively, a single number if the data cover only one year.
#' @param access data access code: \code{"OSPAR"}, \code{"Public"}, or
#'        \code{"Restricted"}.
#' @param content the r code that fetches and saves the data
#'
#' @examples
#' \dontrun{
#'
#' # Create boot folder
#' mkdir("boot")
#'
#' # Create boot script, boot/mydata.R
#' draft.data.script(name="mydata", title="Title", description="Description",
#'                   format="txt", originator="Me", year="2022",
#'                   period=c(2000,2020), access="Public",
#'                   content='write(pi, file="pi.txt")')
#'
#' # Create metadata, boot/DATA.bib
#' taf.roxygenise(files="mydata.R")
#'
#' # Run boot script, creating boot/data/mydata/pi.txt
#' taf.boot()
#' }
#'
#' @importFrom TAF taf.boot.path
#' @importFrom TAF mkdir
#'
#' @export
draft.data.script <- function(name, title, description, format, originator, year,
                              period, access, content) {

  # make names valid doesnt garauntee valid file name,
  # but better than nothing
  name <- make.names(name)

  period <- paste(unlist(period), collapse = "-")

  # make sure content is a single string
  content <- paste(content, collapse = "\n")

  # create boot path
  mkdir(taf.boot.path())

  # write script with header
  cat(
    sprintf("#' %s",title),
    "#'",
    sprintf("#' %s",description),
    "#'",
    sprintf("#' @name %s",name),
    sprintf("#' @format %s",format),
    sprintf("#' @tafOriginator %s",originator),
    sprintf("#' @tafYear %s",year),
    sprintf("#' @tafPeriod %s",period),
    sprintf("#' @tafAccess %s",access),
    "#' @tafSource script",
    content,
    file = taf.boot.path(sprintf("%s.R", name)),
    sep = "\n\n"
  )
}
