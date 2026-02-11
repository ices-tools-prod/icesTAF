#' TAF Skeleton
#'
#' Create initial directories and R scripts for a new TAF analysis using
#' a stock assessment created on stockassessment.org.
#'
#' @param template which template to use. The default is "WKTNET:simple"
#' @param force whether to overwrite existing scripts.
#' @param gitignore whether to add a .gitignore file.
#' @param path where to create initial directories and R scripts. The default is
#'        the current working directory.
#'
#' @return Full path to analysis directory.
#'
#' @seealso
#' \code{\link[TAF]{taf.skeleton}} creates an empty generic TAF skeleton.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#'   taf.template(template = "WKTNET:simple")
#' }
#'
#' @importFrom TAF draft.data taf.skeleton
#' @export

taf.template <- function(template = "WKTNET:simple", force = FALSE, gitignore = TRUE, path = ".") {
  safe.cat <- function(..., file, force = FALSE) {
    if (!file.exists(file) || force) {
      cat(..., file = file)
    } else {
      message(sprintf("File %s exists, not overwriting, overwrite with force = TRUE", file))
    }
  }

  TAF::taf.skeleton(path, pkgs = c("icesTAF"), force = FALSE, gitignore = gitignore)

  owd <- setwd(path)
  on.exit(setwd(owd))

  parts <- strsplit(template, ":")[[1]]
  baseurl <- sprintf("https://raw.githubusercontent.com/ices-eg/%s/refs/heads/main/src/%s/", parts[1], parts[2])

  # get bib file
  template.bib <- TAF::read.bib(paste0(baseurl, "boot/DATA.bib"))

  # download data scripts
  scripts <- names(template.bib[sapply(template.bib, function(x) x$source) == "script"])
  for (script in scripts) {
    code <- readLines(paste0(baseurl, "boot/", script, ".R"))
    safe.cat(
      code,
      sep = "\n",
      file = file.path("boot", paste0(script, ".R")),
      force = force
    )
  }

  # download data files?

  # read original DATA.bib
  original.bib <- TAF::read.bib("boot/DATA.bib")
  if (!force && any(names(template.bib) %in% names(original.bib))) {
    message(
      "Some entries in the template DATA.bib already exist in the original DATA.bib. ",
      "\nUse force = TRUE to overwrite existing entries."
    )
  }

  # replace DATA.bib with new entries
  new.bib <-
    if (force) {
      c(
        original.bib[!names(original.bib) %in% names(template.bib)],
        template.bib
      )
  } else {
      c(
        original.bib,
        template.bib[!names(template.bib) %in% names(original.bib)]
      )
    }

  # rewrite DATA.bib
  args <- do.call(rbind.data.frame, new.bib)[,-c(1:2)]
  args$data.files <- names(new.bib)
  draft.data.script <- function(...) {
    TAF::draft.data(..., data.scripts = NULL, file = TRUE, append = FALSE)
  }

  do.call(draft.data.script, args)

 # copy over any scripts


  message(
    "WKTNET simple template added to: ", normalizePath(path)
  )

  invisible(path)
}
