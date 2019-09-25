
library("states")
states <- state_panel(2012, 2012)
states <- dplyr::filter(states, !gwcode %in% c(396, 397))
states$x <- as.integer(states$gwcode %in% c(2, 260, 490))

test_that("spatlag works and returns correct values", {

  expect_error(
    states$slag_x <- spatlag(states$x, states$gwcode, states$year, NULL),
    NA
  )

  expect_equal(
    states$slag_x[states$gwcode %in% c(20, 210, 220, 230)],
    c(1, .5, .125, 0)
  )

})

