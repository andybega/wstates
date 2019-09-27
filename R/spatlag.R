
#' State W
#'
#' Spatial weights matrix for independent states on a date
#'
#' @param date A Date or YYYY-MM-DD string
#' @param w_func type of spatial weighting function
#' @param ccode Optional vector of numeric G&W country codes to subset by
#'
#' @examples
#' w <- wstates("2010-01-01")
#' w
#' plot(w)
#'
#' @export
wstates <- function(date, w_func = w_contiguity, ccode = NULL) {

  states <- states_geom(date, ccode)
  w <- w_func(sf::st_geometry(states))
  w
}


#' Spatial lagger
#'
#' Spatial lagger for country-year data
#'
#' @param x variable to lag
#' @param ccode vector of numeric G&W country codes to subset
#' @param date vector of date for which to construct state set
#' @param w_func foo
#'
#' @export
spatlag <- function(x, ccode, date, w_func = w_contiguity) {

  stopifnot(inherits(date, "Date"),
            !any(is.na(x)),
            !any(is.na(ccode)),
            !any(is.na(date)))

  x_i     <- split(x, date)
  ccode_i <- split(ccode, date)
  dates   <- as.character(unique(date))

  slag_x  <- lapply(dates, function(date_i) {

    x_ii     <- x_i[[date_i]]
    ccode_ii <- ccode_i[[date_i]]

    geom <- states_geom(as.Date(date_i), ccode_ii)
    geom <- sf::st_geometry(geom)
    w <- w_func(geom)

    slag_x_ii <- w %*% x_ii
    as.vector(slag_x_ii)
  })
  names(slag_x) <- dates

  slag_x <- unsplit(slag_x, date)
  slag_x
}




