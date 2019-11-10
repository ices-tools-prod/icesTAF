#' @rdname icesTAF-internal
#'
#' @importFrom tools file_path_sans_ext
#'
#' @export

## ds = draft.software helper function

ds.file <- function(package, author, year, title, version, source)
{
  key <- file_path_sans_ext(basename(package), compression=TRUE)

  ## Treat null and NA (from mapply) the same, must test null first
  author <- if(is.null(author) || is.na(author)) NULL else author
  year <- if(is.null(year) || is.na(year)) NULL else year
  title <- if(is.null(title) || is.na(title)) NULL else title
  version <- if(is.null(version) || is.na(version)) NULL else version
  source <- if(is.null(source) || is.na(source))
              paste0("initial/software/", basename(package)) else source

  line1 <- paste0("@Misc{", key, ",")
  line2 <- paste0("  author  = {", author, "},")
  line3 <- paste0("  year    = {", year, "},")
  line4 <- paste0("  title   = {", title, "},")
  line5 <- paste0("  version = {", version, "},")
  line6 <- paste0("  source  = {", source, "},")
  line7 <- "}"

  out <- c(line1, line2, line3, line4, line5, line6, line7)
  class(out) <- "Bibtex"

  out
}
