module Components.Grid where


import Html exposing (..)



view address model renderComponent report_data =
  div [] 
    [ text "grid"
    , div [] 
          (List.map (renderComponent address report_data) model.components)
    ]


