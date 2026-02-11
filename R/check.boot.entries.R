#' Check boot data entries
#'
#' Check that all data entries in boot/DATA.bib are present in the boot/data folder
#'
#' @return logical vector indicating which entries are present (TRUE) or missing (FALSE)
#'
#' @importFrom TAF read.bib boot.dir
#' @export
check.boot.data <- function() {
  bib.entries <- read.bib("boot/DATA.bib")

  # todo: check url, and check if data present but not in DATA.bib
  checks <-
    sapply(bib.entries, function(entry) {
      if (entry$source == "file") {
        file.exists(file.path(boot.dir(), "data", entry$key))
      } else if (entry$source %in% c("folder", "script")) {
        if (dir.exists(file.path(boot.dir(), "data", entry$key))) {
          # check if folder/script contains any files
          length(list.files(file.path(boot.dir(), "data", entry$key), recursive = TRUE)) > 0
        } else {
          FALSE
        }
      } else {
        NA
      }
    })

  if (any(!checks, na.rm = TRUE)) {
    missing <- names(checks)[!checks]
    message(
      "- Project boot folder is out of sync:\n  The following data entries are missing:\n",
      paste("  -", missing, collapse = "\n"),
      "\n  Run `TAF::taf.boot()` to update the boot folder with the missing data entries."
    )
  } else {
    message("- All data entries in boot/DATA.bib are present")
  }

  invisible(checks)
}
