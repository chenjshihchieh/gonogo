function(input, output, session){
  rv <- reactiveValues(
    transition = 1,
    q_numb = 0,
    empty = FALSE,
    mistake = FALSE,
    success = FALSE,
    timer = 20,
    timeout = FALSE,
    correct = FALSE,
    display_time = 20
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
    allow_trans = all(!rv$empty, !rv$mistake, !rv$success, rv$q_numb < length(qs), rv$transition > 2)
    if(allow_trans) {
      
      if(qs[rv$q_numb] == 'Go') {
        rv$success = TRUE
        rv$timer = -rv$display_time
      }
      
      if(qs[rv$q_numb] == 'NoGo') {
        rv$mistake = TRUE
        rv$timer = -rv$display_time
      }
      rv$transition = rv$transition+1
      rv$q_numb = rv$q_numb + 1
    }
    
    if(input$keypress == 32 & rv$transition == 2) {
      rv$transition = rv$transition+1
      rv$q_numb = rv$q_numb + 1
    }
  })
  
  #Timer: When the trial starts, the timer will count down from 20 to 0 then repeat.
  #When time runs out rv$timeout becomes true
  observe({
    invalidateLater(100, session)
    isolate({
      allow_trans = all(!rv$empty, !rv$mistake, rv$q_numb < length(qs))
      
      if(rv$mistake & rv$timer < 0) {
        rv$timer = rv$timer + 1
      } else {
        rv$mistake = FALSE
      }
      
      if(rv$success & rv$timer < 0) {
        rv$timer = rv$timer + 1
      } else {
        rv$success = FALSE
      }
      
      if(rv$q_numb >= 1 & rv$timer > 0) {
        rv$timer = rv$timer - 1
      } else if(rv$q_numb >= 1 & rv$timer == 0) {
        rv$timer = rv$display_time
        if(qs[rv$q_numb] == 'NoGo') {
          rv$correct = TRUE
        } else {
          rv$correct = FALSE
        }
        
        if(allow_trans) {
          rv$transition = rv$transition+1
          rv$q_numb = rv$q_numb + 1
        }
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
        fluidRow()
      }else if(rv$mistake) {
        list(
          fluidRow(style='height:250px'),
          fluidRow(h2('Mistake'), 
                   h2(list('Timer:', rv$timer)),
                   h2(list('Transition:', rv$transition)),
                   h2(list('Question Numb:', rv$q_numb)),
                   h2(list('Condition:', qs[rv$q_numb]))
                   )
        )
      }else if(rv$success) {
        list(
          fluidRow(style='height:250px'),
          fluidRow(h2('success'), 
                   h2(list('Timer:', rv$timer)),
                   h2(list('Transition:', rv$transition)),
                   h2(list('Question Numb:', rv$q_numb)),
                   h2(list('Condition:', qs[rv$q_numb]))
          )
        )
      }else if(qs[rv$q_numb] == "Go"){
        list(
          fluidRow(style='height:250px'),
          fluidRow(img(src='green.png', alt='green', style="width:200x;height:100px;vertical-align:middle"),
                   h2(list('Timer:', rv$timer)),
                   h2(list('Transition:', rv$transition)),
                   h2(list('Question Numb:', rv$q_numb)),
                   h2(list('Condition:', qs[rv$q_numb]))
                  )
        )
      }else if(qs[rv$q_numb] == "NoGo"){
        list(
          fluidRow(style='height:250px'),
          fluidRow(img(src='red.png', alt='green', style="width:200x;height:100px;vertical-align:middle"),
                   h2(list('Timer:', rv$timer)),
                   h2(list('Transition:', rv$transition)),
                   h2(list('Question Numb:', rv$q_numb)),
                   h2(list('Condition:', qs[rv$q_numb]))
                   )
        )
      }
    }else {
      h2('Done')
    }
  )
  
  
}