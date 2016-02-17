module Users where

import Html exposing (..)
import Html.Events exposing (onClick, on, targetValue)
import Html.Attributes exposing (class, href)
import StartApp.Simple as StartApp
import Http
import Json.Decode as Json exposing ((:=))
import Effects
import Task


type Action
  = DisplayLol
  | Receiver (Maybe (List String))

type alias User = String

type alias Model =
    { str: String
    , users: List User
}

view address model =
    div [class "container"]
      [ text "user"
      , button [onClick address DisplayLol] []
      , text (toString model.str)
      ]


update action model =
    case action of
        DisplayLol -> {model | str = "lol"}
        Receiver maybeData -> model

init =
    { str = ""
    , users = [] 
    }

bootPage act =
    let decoder =
        Json.list (Json.object1 identity ("username" := Json.string))
    in
        Http.get decoder "http://jsonplaceholder.typicode.com/users"
            |> Task.toMaybe
            |> Task.map act
            |> Effects.task