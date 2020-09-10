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
#' @param access data access code: \code{"OSPAR"}, \code{"Public"}, or
#'        \code{"Restricted"}.
#' @param content the r code that fetches and saves the data
#'
#' @importFrom glue glue
#'
#' @export
draft.data.script <- function(name, title, description, format, originator, year,
                              access, content) {

  # make names valid doesnt garauntee valid file name,
  # but better than nothing
  name <- make.names(name)

  file_contents <-
    glue(
      "# {title}
#
# {description}
#
# @name {name}
# @format {format}
# @tafOriginator {originator}
# @tafYear {year}
# @tafAccess {access}
# @tafSource script
"
    )

  cat(content, file = taf.boot.path(glue("{name}.R")))
}
