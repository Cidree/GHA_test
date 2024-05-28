
# 1. Load packages --------------------------------------------------------

library(bslib)
library(geodata)
library(gt)
library(leaflet)
library(mapview)
library(sf)
library(shiny)
library(tidyverse)

# 2. App ------------------------------------------------------------------

ui <- page_sidebar(
    title   = "Cerambyx dashboard",
    sidebar = sidebar(
        selectInput(
            "year",
            "Year",
            choices  = unique(cerambyx$year),
            selected = 2024
        )
    ),
    layout_columns(
        card(
            leafletOutput("map_cerambyx")
        ),
        card(
            gt_output("table_cerambyx")
        )
    )
)

server <- function(input, output) {

    ## Download data of Cerambyx cerdo
    cerambyx <- reactive({
        read_rds("data/cerambyx.rds")
    })

    filtered_cerambyx <- reactive({
        cerambyx() %>%
            filter(year == input$year)
    })

    output$map_cerambyx <- renderLeaflet({
        m <- mapview(filtered_cerambyx())
        m@map
    })

    output$table_cerambyx <- render_gt({
        cerambyx() %>%
            as_tibble() |>
            select(-geometry) |>
            gt() %>%
            tab_header(
                title = "Cerambyx cerdo",
                subtitle = "Occurrence data"
            ) %>%
            fmt_number(
                columns = c(year),
                decimals = 0
            ) %>%
            fmt_markdown(
                columns = c(verbatimLocality),
                rows = 1:5
            ) %>%
            tab_options(
                table.width = "100%"
            )
    })
}

shinyApp(ui, server)
