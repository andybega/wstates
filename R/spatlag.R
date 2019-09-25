
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
wstates <- function(date, w_func = NULL, ccode = NULL) {

  states <- states_geom(date, ccode)
  w <- w_contiguity(sf::st_geometry(states))
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
spatlag <- function(x, ccode, date, w_func) {

  date <- unique(date)
  date <- "2012-01-01"

  geom <- states_geom(date, ccode)

  spatlag_geom(x, sf::st_geometry(geom), w_func)

}

spatlag_geom <- function(x, geom, w_func) {

  w <- w_contiguity(geom)

  slag_x <- w %*% x
  as.vector(slag_x)

}
