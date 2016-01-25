module Users where

import Html exposing (..)
import Html.Events exposing (onClick, on, targetValue)
import Html.Attributes exposing (class, href)
import System exposing (..)
import StartApp.Simple as StartApp


view address model =
    div [class "container"]
      [ text "user"
      , button [onClick address DisplayLol] []
      , text (toString model.str)
      ]


update action model =
    case action of
        DisplayLol -> {model | str = "lol"}

init =
    { str = "" }