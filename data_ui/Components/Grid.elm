module Components.Grid where


import Html exposing (..)



view address model renderComponent =
  div [] 
    [ text "grid"
    , div [] 
          (List.map (renderComponent address) model.components)
    ]


