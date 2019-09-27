
library("states")
states <- state_panel(as.Date("2011-12-31"), as.Date("2012-12-31"), partial = "exact")
states <- subset(states, !states$gwcode %in% c(396, 397))
states$x <- as.integer(
  (states$gwcode %in% c(2, 260, 490) & states$date=="2011-12-31") |
  (states$gwcode %in% c(2) & states$date=="2012-12-31"))

test_that("spatlag works and returns correct values", {

  expect_error(
    states$slag_x <- spatlag(states$x, states$gwcode, states$date),
    NA
  )

  # check 2011 values
  expect_equal(
    states$slag_x[states$gwcode %in% c(20, 210, 220, 230) & states$date=="2011-12-31"],
    c(1, .5, .125, 0)
  )

  # check 2012 values
  expect_equal(
    states$slag_x[states$gwcode %in% c(20, 210, 220, 230) & states$date=="2012-12-31"],
    c(1, 0, 0, 0)
  )

})


test_that("spatlag errors for missing values in any input vector", {

  year <- as.integer(substr(states$date, 1, 4))
  expect_error(
    spatlag(states$x, states$gwcode, states$year)
  )

  x <- states$x
  x[1] <- NA
  expect_error(
    spatlag(x, states$gwcode, states$date)
  )

  ccode <- states$gwcode
  ccode[1] <- NA
  expect_error(
    spatlag(states$x, ccode, states$date)
  )

  date <- states$date
  date[1] <- NA
  expect_error(
    spatlag(states$x, states$gwcode, date)
  )

})


test_that("w matrices are subset by country code list", {

  data("gwstates")
  gwcode <- states$gwcode
  gwcode <- gwcode[!gwcode %in% gwstates[gwstates$microstate, "gwcode"]]

  states2 <- states[states$gwcode %in% gwcode, ]

  expect_error(
    out <- spatlag(states2$x, states2$gwcode, states2$date),
    NA
  )

})

