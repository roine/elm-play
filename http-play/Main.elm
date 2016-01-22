module GithubGrab where

import Html exposing (div, input, text, button)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (on, targetValue, onClick)
import Http
import Task exposing (Task)
import Json.Decode as Json exposing ((:=))
import String

type Action = NoOp | UpdateSearch String | Response User

type alias User =
  { login: String
  , name: String
  }

type alias Model =
  { loading: Bool
  , user: Maybe User
  , strSearch: String
  }

port runner: Signal (Task String ())
port runner =
  Signal.map getUser request.signal


request =
  Signal.mailbox ""

response =
  Signal.mailbox {}

main =
  Signal.map (view inbox.address) model

view address model =
  div[class "container"]
    [ div[class "model"][text (toString model)]
    , input
      [ placeholder "type a username, i.e.: roine"
      , value model.strSearch
      , on "input" targetValue (UpdateSearch >> Signal.message address)
      ][]
    , button[onClick request.address model.strSearch][text "search"]
    ]

inbox =
  Signal.mailbox NoOp

model =
  Signal.foldp update init inbox.signal

init =
  { loading = False
  , user = {login = "", name = ""}
  , strSearch = ""
  }

update action model =
  case action of
    NoOp -> model
    UpdateSearch str -> {model | strSearch = str}
    Response user ->
      {model | user = user, strSearch = ""}


getUser: String -> Task String ()
getUser username =
  let
    toUrl = if String.length username > 0
      then Task.succeed ("https://api.github.com/users/" ++ username)
      else Task.fail "no username"
  in
    toUrl `Task.andThen` (Task.mapError (always "Not Found") << Http.get userDecoder)
    `Task.andThen` (Response >> Signal.send inbox.address)

userDecoder =
  Json.object2 User ("login" := Json.string) ("name" := Json.string)
