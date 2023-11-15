# This is a Shiny web application.

library(shiny)
library(shinyWidgets)
library(tidyverse)
library(plotly)
library(ggplot2)
library(DT)
library(wordcloud)
library(tm)

BabyNames <- read.csv("Popular_Baby_Names.csv")
BabyNames$Child.s.First.Name <- tolower(BabyNames$Child.s.First.Name)
babynames<- unique(BabyNames)
modified_data <- babynames %>% mutate(Ethnicity = recode(Ethnicity, "BLACK NON HISP" = "BLACK NON HISPANIC" ,
                                                         "ASIAN AND PACI" = "ASIAN AND PACIFIC ISLANDER",
                                                         "WHITE NON HISP" = "WHITE NON HISPANIC" ))


# Define UI
ui <- fluidPage(
  titlePanel("Baby Names"),
  selectInput("ing", "FirstName",
              choices = c( "All", unique(modified_data$Child.s.First.Name))),
  selectInput("EthnicityNames", "Ethnicity",
              choices = c( "All", unique(modified_data$Child.s.First.Name))),
  DTOutput("table")
)


# Define server
server <- function(input, output) {

  # display the table which contains what I want
  output$table <- renderDataTable({

    if (input$ing != "All") {
      selcted <- modified_data[modified_data$Child.s.First.Name == input$ing, ]
    } else{
      selcted <- modified_data
    }

    # another condition:
    if (input$EthnicityNames != "All") {
      selcted <- selcted[selcted$Child.s.First.Name == input$EthnicityNames, ]
    }

    selcted <- selcted
    selcted
  })

}
# Run the application
shinyApp(ui = ui, server = server)
