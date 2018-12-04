library(shiny)
library(rintrojs)

# アプリケーションのUIを定義
ui <- fluidPage(
  
  introjsUI(), # これをUI定義のどこかに含める
  
  # アプリケーションのタイトル
  titlePanel("ヒント表示を追加"),
  
  sidebarLayout(
    # サイドバー
    sidebarPanel(
      introBox( # ヒント表示を追加したい要素を囲む
        # スライダー
        sliderInput("bins", "ビンの数:", min = 1, max = 50, value = 30), # ヒントが追加される要素
        data.hint = "このスライダーを動かしてビンの数を変更してください" # ヒントのメッセージ
      )
    ),
    
    # メインパネル
    mainPanel(
      introBox( # ヒント表示を追加したい要素を囲む
        plotOutput("distPlot"), # ヒントが追加される要素
        data.hint = "スライダーの値に合わせてこのヒストグラムが変化します" # ヒントのメッセージ
      )
    )
  )
)

# サーバー側ロジックを定義
server <- function(input, output, session) {
  
  output$distPlot <- renderPlot({
    # ui.Rから来た input$bins に基づいてビンを生成
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # 指定のビン数でヒストグラムを描画
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  # ヒント表示を有効化
  hintjs(
    session,
    # オプション設定
    options = list(
      hintPosition = "top-left", # ヒントの表示位置
      hintButtonLabel = "了解" # ボタンのラベル
    )
  )
}

# アプリケーションを起動する
shinyApp(ui = ui, server = server)
