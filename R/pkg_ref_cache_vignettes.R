#' Cache a List of Vignettes Files from a Package Reference
#'
#' @inheritParams pkg_ref_cache
#' @family package reference cache
#'
pkg_ref_cache.vignettes <- function(x, name, ...) {
  UseMethod("pkg_ref_cache.vignettes")
}



pkg_ref_cache.vignettes.pkg_remote <- function(x, name, ...) {
  vignettes_from_url(x$web_url)
}


pkg_ref_cache.vignettes.pkg_install <- function(x, name, ...) {
  vignettes_from_dir(system.file(package = x$name))
}



pkg_ref_cache.vignettes.pkg_source <- function(x, name, ...) {
  vignettes_from_dir(x$path)
}



#' Build a List of Vignettes Files Discovered Within a Given Directory
#'
#' @param path a package directory path expected to contain Vignettes files
#'
#' @return a vector of parsed Vignettes files
#'
vignettes_from_dir <- function(path) {
  # accommodate unique vignettes files

  folder <- c(source = "/vignettes", bundle = "/inst/doc", binary = "/doc")
  files <- unlist(lapply(paste0(path, folder), list.files, full.names = TRUE))

  if (!length(files)) return(data.frame())

  file_path = unique(tools::file_path_sans_ext(files))
  filename = basename(file_path)
  names(file_path) <- filename

  file_path = unique(tools::file_path_sans_ext(files))
  filename = basename(file_path)
  names(file_path) <- filename

  file_path[tolower(filename) != tolower("index")]
}

#' Build a List of Vignettes Files Discovered Within a Package Website
#'
#' @param web_html a \code{pkg_ref$web_html} document containing links to Vignettes files
#'
#' @return a vector of Vignettes files
#'
vignettes_from_url <- function(web_html) {

  nodes <- xml2::xml_find_all(web_html, xpath = '//a[contains(@href,"vignettes")]')
  if (!length(nodes)) return(c())

  file_path <- unlist(xml2::xml_attrs(nodes, "href"))

  filename <- tools::file_path_sans_ext(basename(file_path))
  file_path <- sprintf("%s/%s", url, file_path)

  filename <- tools::file_path_sans_ext(basename(file_path))
  file_path <- paste0(url, "/", file_path)
  names(file_path) <- filename

  file_path
}
