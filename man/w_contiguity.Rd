% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wmat.R
\name{w_contiguity}
\alias{w_contiguity}
\title{Contiguity W}
\usage{
w_contiguity(x)
}
\arguments{
\item{x}{inheriting from "sfc"}
}
\description{
Contiguity spatial weights matrix
}
\examples{
data("est_adm1")
w <- w_contiguity(sf::st_geometry(est_adm1))
w
plot(w)

}
