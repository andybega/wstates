
data("est_adm1")

x <- states_geom(as.Date("2010-01-01"))

w <- w_contiguity(sf::st_geometry(x))

data("est_adm1")
w_contiguity(sf::st_geometry(x))
