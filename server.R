function(input, output, session){
  rv <- reactiveValues(
    transition = 1,
    q_numb = 0,
    empty = FALSE,
    mistake = FALSE,
    timer = 20,
    timeout = FALSE
  )
  
  #----------------------------------------------#
  ########observe Events for Transition#############
  #----------------------------------------------#
  # Observe start button to start task
  observeEvent(input$start, {
    if(rv$transition == 1){rv$transition = rv$transition+1}
    })
  
  #Observe space bar to advance tasks
  observeEvent(input$keypress, {
    if(rv$transition > 1) {
      if(input$keypress == 32) {
        rv$transition = rv$transition+1
        rv$q_numb = rv$q_numb + 1
      }
    }
  })
  
  #Timer: When the trial starts, the timer will count down from 20 to 0 then repeat.
  #When time runs out rv$timeout becomes true
  observe({
    invalidateLater(100, session)
    isolate({
      if(rv$q_numb >= 1 & rv$timer > 0) {
        rv$timer = rv$timer - 1
      } else if(rv$q_numb >= 1 & rv$timer == 0) {
        rv$timer = 20
      }
    })
  })
  
  #-----------------------------#
  ########Main UI#############
  #-----------------------------#
  output$mainUI <- renderUI(
    if(rv$transition == 1){
      list(
        img(src='icon/kpuLogo.jpg', alt='kpulogo'),
        br(),
        fluidRow(actionButton('start', 'Start'), align = 'center')
      )
    }else if(rv$transition == 2){
      list(
        h2('In the following trials, only press the space bar if you see the green coloured oval.'),
        img(src='green.png', alt='green', style="width:200x;height:100px;"),
        h2('Do nothing if you see the red colour oval'),
        img(src='red.png', alt='red', style="width:200px;height:100px;"),
        h2('Now, press the space bar to start!')
      )
    }else if(rv$transition > 2 & rv$transition < 2+num_qs){
      
      if(rv$empty) {
        list()
      }else if(rv$mistake) {
        list(
          fluidRow(style='height:250px'),
          fluidRow(h2('Mistake'))
        )
      }else if(qs[rv$q_numb] == "Go"){
        list(
          fluidRow(style='height:250px'),
          fluidRow(img(src='green.png', alt='green', style="width:200x;height:100px;vertical-align:middle"))
        )
      }else if(qs[rv$q_numb] == "NoGo"){
        list(
          fluidRow(style='height:250px'),
          fluidRow(img(src='red.png', alt='green', style="width:200x;height:100px;vertical-align:middle"))
        )
      }
    }else if(rv$transition >= 2+num_qs) {
      h2('Success')
    }
  )
  
  
}