# 必要なパッケージを読み込む
library(shiny)
library(DT)
library(ggplot2)

# UI定義
ui <- fluidPage(
  titlePanel("Let's make violin plot!"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput('file', 'Please upload csv file'),
      actionButton('iris_load', "Use iris dataset"),
      uiOutput("xvar_ui"),
      uiOutput("yvar_ui")
    ),
    
    mainPanel(
      DTOutput('table'),
      plotOutput("violinPlot")
    )
  )
)

# サーバー定義
server <- function(input, output, session) {
  csv <- eventReactive(input$file, {
    req(input$file$datapath)
    file_path <- input$file$datapath
    read.csv(file_path)
  })
  
  observeEvent(csv(), {
    updateSelectInput(session, "xvar", choices = names(csv()), selected = names(csv())[1])
    updateSelectInput(session, "yvar", choices = names(csv()), selected = names(csv())[2])
  })
  
  output$xvar_ui <- renderUI({
    selectInput("xvar", "X軸の変数を選択:", choices = NULL)
  })
  
  output$yvar_ui <- renderUI({
    selectInput("yvar", "Y軸の変数を選択:", choices = NULL)
  })
  
  output$table <- renderDT({
    datatable(csv())
  })
  
  output$violinPlot <- renderPlot({
    req(csv())
    data <- csv()
    ggplot(data, aes_string(x = input$xvar, y = input$yvar)) +
      geom_violin(trim = FALSE) +
      geom_jitter(width = 0.2, size = 1) +
      labs(x = input$xvar, y = input$yvar) +
      theme_minimal()
  })
}

# アプリケーションを実行
shinyApp(ui = ui, server = server)