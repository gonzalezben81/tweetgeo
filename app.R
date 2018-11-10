#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(twitteR)

api_key <- "u4a6iqPs58FvQydRpqVQHpiIy"

api_secret <- "cFAQLO5KjAQ3DF5XmdrFzJKlekc8sNQXfdrvD7p0Jsls7oQWmP"

access_token <- "	4808407757-wJeb7o4shlAV8SJfvOPzRbH5PTel5vZE9NAzt6o"

access_token_secret <- "KspPEnRW29bk40kNqlAMRRxqynjaFp8VOeaXHnn5jYEuU"

setup_twitter_oauth(api_key,api_secret)

library(shiny)

library(DT)
library(ROAuth)
library(RCurl)
library(dplyr)
library(purrr)
library(XLConnect)
library(ggplot2)
library(tidytext)
library(tidyr)
library(lubridate)
library(scales)
library(stringr)
library(wordcloud)
library(tm)
library(ggplot2)
library(DT)
library(plyr)
library(xtable)
library(syuzhet)



# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$head(includeScript("www/google-analytics.js")),
   # Application title
   titlePanel("Twitter Search"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
      
      dateInput(label = "Date Range",inputId = "date",start = "date1"),
      textInput(label = "Twitter Phrase",inputId = "phrase"),
      textInput(label = "Geo code",inputId = "geocode",value = '38.627003,-90.199402,10mi'),
      #hr(),
      #actionButton(inputId = "do",label = "Get Twitter Data"),
      hr(),
      actionButton(inputId = "display",label = "Create Twitter Table")
      
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(
          tabPanel(title = "Table",DT::dataTableOutput("table"))
          
        )
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   
  
  ###Creates Twitter Data Frame
  tweetdf <- reactive({
    withProgress(message = 'Creating Twitter Data Table',
                 value = 0, {
                   for (i in 1:10) {
                     incProgress(1/10)
                     Sys.sleep(0.25)
                   }
                 },env = parent.frame(n=1))
    # generate bins based on input$bins from ui.R
    tweets<- searchTwitteR(searchString = input$phrase,n = 15,since = input$date1,geocode = input$geocode)
    
    tweets<-tbl_df(map_df(tweets,as.data.frame))
    tweets
  })
  # 
  eventReactive(input$display,{output$table<-DT::renderDataTable(tweetdf(), options = list(lengthChange = TRUE,autoWidth = TRUE,scrollX = TRUE),filter='top',
                                                                class = "cell-border stripe")})

  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

