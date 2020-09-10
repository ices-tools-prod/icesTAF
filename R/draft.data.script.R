#' Draft or create a bootstrap data script
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
#' @importFrom glue glue
#'
#' @export
draft.data.script <- function(name, title, description, format, originator, year,
                              period, access, content) {

  # set up template
  header <-
"# {title}
#
# {description}
#
# @name {name}
# @format {format}
# @tafOriginator {originator}
# @tafYear {year}
# @tafPeriod {period}
# @tafAccess {access}
# @tafSource script
"
  header <- gsub("#", "#'", header)

  # make names valid doesnt garauntee valid file name,
  # but better than nothing
  name <- make.names(name)
  period <- paste(unlist(period), collapse = "-")

  # make sure content is a single string
  content <- paste(content, collapse = "\n")

  cat(
    glue(header), content,
    file = taf.boot.path(glue("{name}.R")),
    sep = "\n\n"
  )
}
