library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
    titlePanel("My perfect diamond choice"),
    
    # Sidebar
    sidebarLayout(
        sidebarPanel(
            helpText("The carachteristics of the diamond you are looking for"),
            numericInput('carat', 'weight of the diamond (carat):', 0.7, min = 0.2, max = 5.0),
            checkboxGroupInput('cut', 'quality of the cut:', c("Fair", "Good", "Very Good", "Premium", "Ideal"), selected = c("Good","Very Good")),
            checkboxGroupInput('clarity', 'clarity of the diamond:', c("level1_Worst(I1)"="I1", "level2(SI2)"="SI2", "level3(SI1)"="SI1", "level4(VS2)"="VS2", "level5(VS1)"="VS1", "level6(VVS2)"="VVS2", "level7(VVS1)"="VVS1", "level8_Best(IF)"="IF"), selected = c("VS2","VS1","VVS2")),
            checkboxGroupInput('color', 'color of the diamond:', c("level1_Worst(D)"="D", "level2(E)"="E", "level3(F)"="F", "level4(G)"="G", "level5(H)"="H", "level6(I)"="I", "level7_best(J)"="J"), selected = c("F","G","H")),
            sliderInput('price', 'price (in dollars)', min=326, max=18823, value=c(326,18823), step=100),
        ),
        mainPanel(
            dataTableOutput('table')
        )
    )
    )
)

# Define server logic required to draw a histogram
library(dplyr)

server <- shinyServer(function(input, output){
    # Show the result corresponding to the filters
    output$table <- renderDataTable({
        price_seq <- seq(from = input$price[1], to = input$price[2], by = 1)
        data <- transmute(diamonds, diamonds = rownames(diamonds), Price = price, 
                          Carat = carat, Cut = cut, Color = color,
                          Clarity = clarity)
        data <- filter(data, Price %in% price_seq, 
                       Carat %in% input$carat, Cut %in% input$cut, 
                       Color %in% input$color, Clarity %in% input$clarity, 
        )
        data <- arrange(data, Price)
        data
    }, options = list(lengthMenu = c(5, 15, 30), pageLength = 30))
    }
)

# Run the application 
shinyApp(ui = ui, server = server)
