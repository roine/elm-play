{--
 - Http request
 - Effects
 - Tasks
 - Json Decode 
 - Multiple value type in json decode for one
--}


module RandomGifViewer where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on, targetValue)
import Effects
import Json.Decode as Json exposing ((:=))
import Http
import Task

type alias User =
  { avatar_url: String
  , name: String
  }

type alias Model =
  { topic: String
  , user: User
  }

type Action = NoOp | RequestMore | UpdateTopic String | NewUser (Maybe User)

noFx model =
  (model, Effects.none)

inputs =
  []

view address model =
  div [] 
    [ div [] [text (toString model)]
    , input [ on "input" targetValue (\str -> Signal.message address (UpdateTopic str)), value model.topic ] []
    , button [onClick address RequestMore] [text "get more"]
    , img [src model.user.avatar_url] []
    ]

update action model =
  case action of
    NoOp -> noFx model
    UpdateTopic newTopic -> noFx { model | topic = newTopic }
    RequestMore -> (model, requestGif model.topic)
    NewUser newUser -> noFx { model | user = Maybe.withDefault model.user newUser}

requestGif topic =
  Http.get decodeUrl ("https://api.github.com/users/" ++ topic)
  |> Task.toMaybe
  |> Task.map NewUser
  |> Effects.task

decodeUrl =
  Json.object2 User ("avatar_url" := Json.string) ("name" := Json.oneOf [Json.string, Json.null ""])

init =
  noFx (Model "lol" {avatar_url = "", name = ""})
