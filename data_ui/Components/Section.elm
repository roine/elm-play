module Components.Section where

import Html exposing (..)

import Components.Date
import Components.Text
import Components.System exposing (..)


type alias Model = Section

view address model =
  div [] 
    [ text "section"
    , div [] 
          (List.map (renderComponent address) model.components)
    ]


renderComponent address component =
  --text (toString component)
  case component of
    T t -> Components.Text.view address t
    D d -> Components.Date.view address d
    S s -> view address s