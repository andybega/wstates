
#' State borders
#'
#' Get correct set of state borders for a date
#'
#' @param date A Date or YYYY-MM-DD string
#' @param ccode Vector of numeric G&W country codes to subset the result by
#'
#' @examples
#' x <- states_geom("2010-01-01")
#' x
#'
#' @export
states_geom <- function(date, ccode = NULL) {
  stopifnot(length(date)==1,
            all(!duplicated(ccode)))

  date <- as.Date(date, origin = "1970-01-01")
  geom <- read_cshapes(date)

  if (!is.null(ccode)) {

    # make sure all input ccode's match a statelist ccode
    nomatch <- ccode[!ccode %in% geom$GWCODE]
    if (length(nomatch) > 0) {
      stop(sprintf("One or more input country codes are invalid: %s",
                   paste0(nomatch, collapse = ", ")))
    }

    geom <- geom[match(ccode, geom$GWCODE), ]
  }
  geom
}

#' Cshapes reader
#'
#' To avoid warnings, and convert to sf object
#'
#' @param date A Date value
#'
#' @export
read_cshapes <- function(date) {
  stopifnot(inherits(date, "Date"))
  geom <- suppressWarnings(cshapes::cshp(date))
  geom <- sf::st_as_sf(geom)
  geom
}
