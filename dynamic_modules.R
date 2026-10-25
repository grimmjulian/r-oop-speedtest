library(shiny)

mod_ui <- function(id) {
  label <- paste("For Input", id)
  ns <- NS(id)
  shiny::tagList(
    numericInput(ns("in"), value = 0, label = label)
  ) |>
    tags$div(id = ns("mod"))
}

mod_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input[["in"]])
  })
}

ui <- fluidPage(
  verbatimTextOutput("output"),
  mod_ui("1"),
  actionButton("add", "add element"),
  actionButton("remove", "remove element")
)

server <- function(input, output, session) {
  a <- reactiveVal(0)

  setup_module <- function(id) {
    idx <- as.numeric(id)
    val <- mod_server(as.character(id))

    observeEvent(val(), {
      current <- a()
      current[idx] <- val()
      a(current)
    })
  }

  setup_module(1)

  output$output <- renderText(a())
  observeEvent(input$add, {
    a(c(a(), 0))
    l <- length(a())
    setup_module(l)
    insertUI(
      selector = "#add",
      where = "beforeBegin",
      ui = mod_ui(as.character(l))
    )
  })
  observeEvent(input$remove, {
    l <- length(a())
    if (l > 1) {
      a(a()[-l])
      selector <- paste0("#", l, "-mod")
      removeUI(
        selector = selector
      )
    }
  })
}

shiny::shinyApp(ui, server)
