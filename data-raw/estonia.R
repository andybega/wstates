
library("raster")
library("sf")
library("dplyr")
library("usethis")

capitals <- data.frame(
  HASC_1 = c("EE.HA", "EE.HI", "EE.IV", "EE.JR", "EE.JN", "EE.LN", "EE.LV",
             "EE.PR", "EE.PL", "EE.RA", "EE.SA", "EE.TA", "EE.VG", "EE.VD",
             "EE.VR"),
  city = c("Tallinn", "K\u00e4rdla", "J\u00f5hvi", "Paide", "J\u00f5geva",
           "Haapsalu", "Rakvere", "P\u00e4rnu", "P\u00f5lva", "Rapla",
           "Kuressaare", "Tartu", "Valga", "Viljandi", "V\u00f5ru"),
  caplong = c(24.75, 22.74, 27.40, 25.54, 26.39,
              23.54, 26.36, 24.50, 27.07, 24.80,
              22.49, 26.73, 26.06, 25.59, 27.01),
  caplat  = c(59.44, 59.00, 59.35, 58.89, 58.74,
              58.94, 59.35, 58.39, 58.07, 59.00,
              58.26, 58.38, 57.78, 58.36, 57.84),
  stringsAsFactors = FALSE
)

adm1 <- raster::getData("GADM", country = "EST", level = 1, path = "data-raw") %>%
  st_as_sf() %>%
  dplyr::filter(TYPE_1!="Water body") %>%
  dplyr::select(GID_0, NAME_0, GID_1, NAME_1, TYPE_1, ENGTYPE_1, HASC_1) %>%
  st_transform(3301) %>%
  # from 9.5 Mb to 0.3 Mb, 97% reduction
  st_simplify(dTolerance = 100, preserveTopology = FALSE) %>%
  st_set_geometry(., st_cast(st_geometry(.), "MULTIPOLYGON")) %>%
  left_join(capitals, by = "HASC_1")


est_adm1 <- adm1
usethis::use_data(est_adm1, overwrite = TRUE)

