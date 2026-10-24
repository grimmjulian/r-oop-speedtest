library(shiny)

input_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    tags$h3(id),
    numericInput(ns("input"), value = 0, label = "Module input")
  )
}

input_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
                        a <- reactive(input$input)
    return(a)
  })
}

ui <- fluidPage(
  verbatimTextOutput("output"),
  input_ui("input_0"),
  actionButton("Add", "add element")
)

server <- function(input, output, session) {
  a <- input_server("input_0")
  output$output <- renderText(a())
}

shiny::shinyApp(ui, server)
