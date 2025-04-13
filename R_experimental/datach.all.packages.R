
detach.all.packages <- function(keep = NULL) {
  basic.packages <-
    paste0(
      "package:",
      c(
        "stats", "graphics", "grDevices", "utils",
        "datasets", "methods", "base", keep
      )
    )
  package.list <- grep("package:", search(), value = TRUE)
  # will only work if there are no dependent packages
  # could force by looping until all packages detached
  for (package in setdiff(package.list, basic.packages)) {
    detach(package, character.only = TRUE)
  }
}
