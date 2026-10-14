s7 <- S7::new_class(
  "s7",
  properties = list(number = S7::class_numeric, text = S7::class_character)
)

foo <- function() {
  a <- s7()
  a@number <- 1
  a@text <- "julian"
  a
}

r6 <- R6::R6Class(
  "r6",
  public = list(number = NA_real_, text = NA_character_),
  active = list(
    number2 = function(value) {
      if (missing(value)) {
        return(self$number)
      } else {
        stopifnot(is.numeric(value))
        self$number <- value
      }
    },
    text2 = function(value) {
      if (missing(value)) {
        return(self$text)
      } else {
        stopifnot(is.character(value))
        self$text <- value
      }
    }
  )
)

bar <- function() {
  a <- r6$new()
  a$number2 <- 1
  a$text2 <- "julian"
  a
}

setClass("s4", representation(text = "character", age = "numeric"))

foobar <- function() {
  a <- methods::new("s4")
  a@text <- "julian"
  a@age <- 1
  a
}

microbenchmark::microbenchmark(S7 = foo(), R6 = bar(), S4 = foobar(), times = 10000)
