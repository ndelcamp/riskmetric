#' Cache package's Maintainer
#'
#' @inheritParams pkg_ref_cache
#' @family package reference cache
#'
pkg_ref_cache.maintainer <- function(x, name, ...) {
  UseMethod("pkg_ref_cache.maintainer")
}



pkg_ref_cache.maintainer.pkg_remote <- function(x, name, ...) {
  db  <- rvest::html_table(x$web_html)[[1]]
  maintainer <- db[grep("Maintainer",db[,1], ignore.case = TRUE) ,2]
  maintainer
}



pkg_ref_cache.maintainer.pkg_install <- function(x, name, ...) {
  if ("Maintainer" %in% colnames(x$description))
    return(x$description[,"Maintainer"])

  a   <- if ("Author" %in% colnames(x$description)) x$description[,"Author"] else NA
  a_r <- if ("Authors@R" %in% colnames(x$description)) x$description[,"Authors@R"] else NA

  if (!is.na(a_r)) {
    a_r_exp <- parse(text = a_r)
    if (all(all.names(a_r_exp, unique = TRUE) %in% c("c", "person"))) {
      return(grep("cre", eval(a_r_exp), value = TRUE))
    }
  } else if (!is.na(a)) {
    return(trimws(strsplit(a, ","))[[1]])
  }

  NA
}



pkg_ref_cache.maintainer.pkg_source <- pkg_ref_cache.maintainer.pkg_install
