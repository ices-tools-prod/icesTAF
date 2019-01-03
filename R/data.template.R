data.template <- function(originator=NULL, year=NULL, title=NULL, period=NULL,
                          source="file", file="",
                          data.dir="bootstrap/initial/data",
                          data.files=dir(data.dir,recursive=TRUE))
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
  output <- data.frame(line1, line2, line3, line4, line5, line6, line7, line8)
  output <- c(t(output))
  output <- output[-length(output)]  # remove empty line at end
  class(output) <- "Bibtex"

  ## 3  Export
  ## Avoid write() when file="", to ensure quiet assignment x <- data.template()
  if(file == "")
  {
    output
  }
  else
  {
    write(output, file=file)
    invisible(output)
  }
}
