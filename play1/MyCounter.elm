module MyCounter where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import StartApp.Simple


view address model =
  div [class "container"]
    [ button [onClick address Decrement] [text "-"],
      text (toString model),
      button [onClick address Increment] [text "+"]
    ]

type alias Model = Int

type Action = Increment | Decrement

update action model =
  case action of
    Increment ->
      model + 1
    Decrement ->
      model - 1
