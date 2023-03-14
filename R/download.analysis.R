#' Download a TAF analysis
#'
#' Download the code for a TAF analysis from GitHub.
#'
#' @param repo The full name of the GitHub repository, e.g. "ices-taf/2019_san.sa.6".
#' @param dir the directory to place the TAF project
#'
#' @seealso
#'
#' \link{run.analysis}
#'
#' @examples
#' \dontrun{
#'
#' library(icesTAF)
#'
#' # Download a TAF analysis
#' run_dir <- download.analysis("ices-taf/2019_san.sa.6", dir = ".")
#'
#' # run the analysis
#' run.analysis(run_dir)
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom TAF cp
#' @importFrom utils download.file unzip
#'
#' @export

download.analysis <- function(repo, dir = tempdir()) {
  branches <- c("main", "master")

  zip_urls <-
    paste0(
      "https://github.com/", repo, "/archive/refs/heads/",
      branches, ".zip"
    )
  destfile <-
    paste0(
      file.path(dir, basename(repo)),
      format(Sys.time(), "-%Y%m%d-%H%M%S"),
      ".zip"
    )

  for (zip_url in zip_urls) {
    res <-
      try(
        suppressWarnings(
          download.file(zip_url, destfile = destfile)
        ),
        silent = TRUE
      )
    if (!inherits(res, "try-error")) break
  }

  files <- unzip(destfile, list = TRUE)
  zipdir <- gsub("/", "", files$Name[1])
  files <- files[files$Length > 0, ]

  files_to_get <-
    c(
      grep("*[.]R", files$Name, value = TRUE),
      grep("*/boot/initial/*", files$Name, value = TRUE),
      grep("*/bootstrap/initial/*", files$Name, value = TRUE),
      grep("*[.]bib", files$Name, value = TRUE)
    )

  unzip(destfile, exdir = dir, files = files_to_get)

  outdir <- file_path_sans_ext(destfile)

  dir.create(outdir)
  cp(file.path(dir, zipdir, "*"), outdir)
  # clean up?
  unlink(destfile)
  unlink(zipdir, recursive = TRUE)

  message("repo: ", repo, " has been downloaded to: ", dir)
  outdir
}
