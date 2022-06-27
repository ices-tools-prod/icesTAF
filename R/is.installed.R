
#' @importFrom utils installed.packages
is.installed <- function(pkg) {
  pkg %in% installed.packages()[, "Package"]
}
