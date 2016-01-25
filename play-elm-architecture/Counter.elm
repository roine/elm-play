module Counter where

import Html exposing (..)
import Html.Events exposing (..)

type Action = NoOp | Increment | Decrement
type alias Model = Int

view: Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [onClick address Decrement] [text "-"]
    , text (toString model)
    , button [onClick address Increment] [text "+"]
    ]



update action model =
  case action of
    NoOp -> model
    Increment -> model + 1
    Decrement -> model - 1

init val =
    val

