# 必要なパッケージを読み込む
library(shiny)
library(ggplot2)

# UI定義
ui <- fluidPage(
  titlePanel("Let's make violin plot!"),
  
  sidebarLayout(
    sidebarPanel(
      actionButton('iris_load', "Use iris dataset"),
      selectInput("xvar", "X軸の変数を選択:", 
                  choices = names(iris), 
                  selected = names(iris)[1]),
      selectInput("yvar", "Y軸の変数を選択:", 
                  choices = names(iris)[1:4], 
                  selected = names(iris)[2])
    ),
    
    mainPanel(
      plotOutput("violinPlot")
    )
  )
)

# サーバー定義
server <- function(input, output) {
  
  output$violinPlot <- renderPlot({
    ggplot(iris, aes_string(x = input$xvar, y = input$yvar)) +
      geom_violin(trim = FALSE) +
      geom_jitter(width = 0.2, size = 1) +
      labs(x = input$xvar, y = input$yvar) +
      theme_minimal()
  })
}

# アプリケーションを実行
shinyApp(ui = ui, server = server)