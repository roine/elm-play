module Counter where

import Html exposing (..)
import Html.Events exposing (onClick)

type alias Model = Int

type Action = NoOp | Increment | Decrement

type alias Context =
    { actions: Signal.Address Action
    , remove: Signal.Address ()
    }

view address model =
    div[] 
        [ div [] [text (toString model)]
        , button [onClick address Decrement] [text "-"]
        , button [onClick address Increment] [text "+"]]

viewWithContext context model =
    div[] 
        [ div [] [text (toString model)]
        , button [onClick context.actions Decrement] [text "-"]
        , button [onClick context.actions Increment] [text "+"]
        , button [onClick context.remove ()] [text "remove"]]

update action model =
    case action of
        NoOp -> model
        Increment -> model + 1
        Decrement -> model - 1

init = 0