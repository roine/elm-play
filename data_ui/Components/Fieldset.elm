module Components.Fieldset where


import Html exposing (..)



view address model renderComponent report_data =
  div [] 
    [ text "fieldset"
    , div [] 
          (List.map (renderComponent address report_data) model.components)
    ]


