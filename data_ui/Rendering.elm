module Rendering where

import Html exposing (..)
import Json.Decode exposing ((:=))
import StartApp
import Effects
import Dict

import Components.Date
import Components.Text
import Components.Section
import Components.System exposing (..)

type Action = NoOp


type alias Model =
  { configuration: { components: List Component }}

app =
  StartApp.start 
    { view = view
    , update = update
    , init = init
    , inputs = []
    }

main =
  app.html


renderComponent address component =
  case component of
    T t -> Components.Text.view address t
    D d -> Components.Date.view address d
    S s -> Components.Section.view address s


view address model =
  div [] 
    [ text (toString model),
      div [] 
      (List.map (renderComponent address) model.configuration.components)
    ]


initialComponents' = 
  { components = [
        T { type' = "text", placeholder = "my text", path = [ "v1_report", "adverse_event_details", "event_details_fieldset", "start_date" ]}
      , D { type' = "date", placeholder = "My Date", path = [ "v1_report", "adverse_event_details", "event_details_fieldset", "company_aware_date" ]}
      , D { type' = "date", placeholder = "My Date", path = [ "v1_report", "adverse_event_details", "event_details_fieldset", "adverse_event_description" ]}
      , S { type' = "section", components = [
            T {type' = "text", placeholder = "Nested", path = [ "v1_report", "adverse_event_details", "event_details_fieldset", "start_date" ]}
            ,S { type' = "section", components = [
              T {type' = "text", placeholder = "Nested", path = [ "v1_report", "adverse_event_details", "event_details_fieldset", "start_date" ]}
          ]}
        ]}
    ]}


init =
  (Model initialComponents', Effects.none)


update action model =
  case action of
    NoOp -> (model, Effects.none)