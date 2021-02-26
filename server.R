function(input, output, session){
  rv <- reactiveValues(
    transition = 1,
    q_numb = 1
  )
  
  #----------------------------------------------#
  ########observe Events for Transition#############
  #----------------------------------------------#
  # Observe start button to start task
  observeEvent(input$start, {
    if(rv$transition == 1){rv$transition = rv$transition+1}
    })
  
  #Observe space bar to advance tasks
  
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
    }else if(rv$transition > 2 & rv$transition < 2+num_qs){}
  )
  
  
}