module Counter where

import Html exposing (..)
import Html.Events exposing (onClick)

type alias Model = Int

type Action = NoOp | Increment | Decrement

view address model =
    div[] 
        [ div [] [text (toString model)]
        , button [onClick address Decrement] [text "-"]
        , button [onClick address Increment] [text "+"]]

update action model =
    case action of
        NoOp -> model
        Increment -> model + 1
        Decrement -> model - 1

init = 0