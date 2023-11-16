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
  selectInput("FirstName", "First Name",
              choices = c( "All", unique(modified_data$Child.s.First.Name))),
  selectInput("EthnicityNames", "Ethnicity",
              choices = c( "All", unique(modified_data$Ethnicity))),
  selectInput("Gender", "Gender",
              choices = c( "All", unique(modified_data$Gender))),
  selectInput("YearOfBirth", "Year of Birth",
              choices = c( "All", unique(modified_data$Year.of.Birth))),
  DTOutput("table")
)


# Define server
server <- function(input, output) {

  # display the table which contains what I want
  output$table <- renderDataTable({
    selected_data <- modified_data

    if (input$FirstName != "All") {
      selected_data <- filter(selected_data, Child.s.First.Name == input$FirstName)
    }
    # another condition:
    if (input$EthnicityNames != "All") {
      selected_data <- filter(selected_data, Ethnicity == input$EthnicityNames)
    }
    if (input$Gender != "All"){
      selected_data <- filter(selected_data, Gender == input$Gender)
    }
    if (input$YearOfBirth != "All") {
      selected_data <- filter(selected_data, Year.of.Birth == input$YearOfBirth)
    }

    selected_data
  })

}
# Run the application
shinyApp(ui = ui, server = server)
