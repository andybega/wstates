
#' Spatial weights matrix
#'
#' Spatial weights matrix class / constructor
#'
#' @param w a matrix
#' @param geom geometry from which the matrix was constructed. Used for plotting.
#' @param coords Alternative coordinates to use when plotting, otherwise
#'   will default to centroids.
#'
#' @examples
#' data("est_adm1")
#' w <- w_contiguity(sf::st_geometry(est_adm1))
#' w
#' plot(w)
#'
#' # the vertices default to centroid coordinates; this can be changed by
#' # setting alternative coordinates
#' coords <- st_as_sf(as.data.frame(est_adm1), coords = c("caplong", "caplat"),
#'                    remove = TRUE, crs = 4326)
#' coords <- st_geometry(coords)
#' w <- set_coords(w, coords)
#' plot(w)
#'
#' @export
wmat <- function(w, geom, coords = NULL) {
  attr(w, "geometry") <- geom
  if (!is.null(coords)) {
    w <- set_coords(w, coords)
  }
  class(w) <- "wmat"
  w
}

#' Set coordinates for weights matrix
#'
#' Set coordinates that are used to plot vertices for the weights matrix.
#'
#' @param x a [wmat()] object
#' @param coords an object inheriting from "sfc_POINT", see [sf::st_sfc()] and
#'   [sf::st_point()].
#'
#' @details The weights matrices returned by [w_contiguity()] etc. return a
#'   [wmat()] object without the optional "coords" argument that is used to
#'   plot the vertices. `set_vertices` allows setting these after the fact,
#'   and is used for example internally in [wstates()] to set the coords to
#'   the state capital coordinates.
#'
#' @export
set_coords <- function(x, coords) {
  stopifnot(inherits(x, "wmat"),
            inherits(coords, "sfc_POINT"))
  coords <- sf::st_transform(coords, crs = sf::st_crs(attr(x, "geometry")))
  attr(x, "coords") <- coords
  x
}


#' @export
print.wmat <- function(x, ...) {
  cat(sprintf("Spatial weights matrix [%s x %s]", ncol(x), ncol(x)), fill = TRUE)
  invisible(x)
}

#' @export
plot.wmat <- function(x, ...) {
  geom <- sf::st_geometry(attr(x, "geometry"))
  if (!is.null(attr(x, "coords"))) {
    vertices <- attr(x, "coords")
  } else {
    vertices <- sf::st_centroid(geom)
  }

  net <- network::network(x, directed = FALSE)
  plot(geom)
  plot(net, coord = sf::st_coordinates(vertices), new = FALSE, vertex.cex = .5)
  invisible(x)
}




#' Contiguity W
#'
#' Contiguity spatial weights matrix
#'
#' @param x inheriting from "sfc"
#'
#' @examples
#' data("est_adm1")
#' w <- w_contiguity(sf::st_geometry(est_adm1))
#'
#' @export
w_contiguity <- function(x) {
  stopifnot(inherits(x, "sfc"))
  geom <- x
  w <- spdep::poly2nb(geom, queen = FALSE)
  w <- spdep::nb2mat(w, style = "W", zero.policy = TRUE)
  wmat(w, geom)
}





w_dist <- function(x) {
  x %>%
    sf::st_centroid() %>%
    sf::st_distance() %>%
    units::set_units("km")
}

#' Inverse distance weight
#'
#' Power distance weights.
#'
#' @param x a geometry collection
#' @param alpha exponent for distance weights
#'
#' @examples
#' data("est_adm1")
#' w <- w_dist_power(sf::st_geometry(est_adm1), alpha = 1)
#'
#' @export
w_dist_power <- function(x, alpha = 1) {
  dist_mat <- w_dist(x)

  # apply power transform
  w <- dist_mat %>%
    unclass() %>%
    `^`(-alpha) %>%
    `diag<-`(0)

  # row-normalize
  w <- apply(w, 1, function(x) {
    x * 1 / sum(x)
  }) %>% t()

  w
}
