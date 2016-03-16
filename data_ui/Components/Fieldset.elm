module Components.Fieldset where


import Html exposing (..)



view address model renderComponent =
  div [] 
    [ text "fieldset"
    , div [] 
          (List.map (renderComponent address) model.components)
    ]


