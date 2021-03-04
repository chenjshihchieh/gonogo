fluidPage(
  tags$head(
    tags$script('
                $(document).on("keydown", function (e) {
                Shiny.onInputChange("keypress", e.keyCode || e.which, {priority: "event"});
                });
                ')
    ),
  uiOutput('mainUI', align = 'center')
)