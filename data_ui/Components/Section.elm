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
  case component of
    TagsInput t -> Components.Text.view address t
    Fieldset t -> Components.Text.view address t
    Grid t -> Components.Text.view address t
    Toggle t -> Components.Text.view address t
    Text t -> Components.Text.view address t
    DatePicker t -> Components.Date.view address t
    TextArea t -> Components.Text.view address t
    RadioButtons t -> Components.Text.view address t
    Number t -> Components.Text.view address t
    Select t -> Components.Text.view address t