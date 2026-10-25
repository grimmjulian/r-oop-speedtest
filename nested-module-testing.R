library(shiny)

input_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    numericInput(ns("input"), value = 0, label = "Module input")
  )
}

input_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    input$input
  })
}

module_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    input_ui(ns("mod_input")),
    verbatimTextOutput(ns("mod_output"))
  )
}

module_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    a <- reactiveVal()
    observeEvent(input_server("mod_input"), {
      a(input_server("mod_input"))
    })
    output$mod_output <- renderText({
      paste("Double the module input", 2 * a())
    })
  })
}

ui <- fluidPage(
  module_ui("mod"),
  numericInput("easy_input", value = 0, label = "Easy Input"),
  verbatimTextOutput("easy_output")
)

server <- function(input, output, session) {
  output$easy_output <- renderText({
    a <- input$easy_input
    paste("Double the easy input", 2 * a)
  })
  module_server("mod")
}

# shiny::shinyApp(ui, server)

testServer(server, {
  message("Start test server function")
  message("inital easy input is null", is.null(input$easy_input))
  session$setInputs(easy_input = 1)
  message("easy output is:", output$easy_output)
})

testServer(module_server, {
  message("Start test module_server function")
  message(
    "Ich kann den input in meinem Module selber setzen, ",
    "indem ich selber die ID setze"
  )
  session$setInputs(`mod_input-input` = 1)
  message("mod output is:", output$mod_output)
  message(
    "Aber kann ich irgendiwe den output von input_server direkt setzen, falls es was komplizierters ist?"
  )

  message("das ist a ", a())
  a(14)
  message("das ist neues a ", a())
  session$flushReact()
  message("mod output is:", output$mod_output)
})
