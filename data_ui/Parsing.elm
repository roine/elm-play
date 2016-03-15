module Parsing where

import Html exposing (..)
import StartApp
import Effects
import Task
import Http
import Json.Decode as Json exposing ((:=))

type alias Model = 
  { configuration: Configuration
  }

type alias Configuration =
  { path_name: String
  , label: String
  }

type Action = NoOp | AddConfiguration (Maybe Configuration)

app = 
  StartApp.start
    { update = update
    , view = view
    , init = init
    , inputs = []
    }

main =
  app.html

init =
  (Model {path_name = "", label = ""}, fetchConfiguration)

view address model =
  div [] [text "bonjour"
  , text (toString model)]

update action model =
  case action of 
    NoOp -> (model, Effects.none)
    AddConfiguration conf -> ({ model | configuration = Maybe.withDefault model.configuration conf}, Effects.none)


fetchConfiguration =
  Http.get decodeConfiguration "/configuration.json"
  |> Task.toMaybe
  |> Task.map AddConfiguration
  |> Effects.task

decodeConfiguration =
  Json.object1 identity (Json.at ["result", "configuration"] 
    (Json.object2 Configuration 
      ("path_name" := Json.string)
      ("label" := Json.string)
    )
  )

port tasks : Signal (Task.Task Effects.Never ())
port tasks = 
  app.tasks

