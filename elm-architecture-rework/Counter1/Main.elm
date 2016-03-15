module Main where
import Html exposing (..)
import Counter

type Action = NoOp | Counter Counter.Action

type alias Model = 
    { counter: Counter.Model
    }

update: Action -> Model -> Model
update action model =
    case action of 
        NoOp -> model
        Counter act ->
            {model | counter = Counter.update act model.counter}

view: Signal.Address Action -> Model -> Html
view address model =
    div [] 
        [ Counter.view (Signal.forwardTo address Counter) model.counter
        , text (toString model)]

box =
    Signal.mailbox NoOp

init =
    {counter = Counter.init}

model = 
    Signal.foldp update init box.signal

main =
    Signal.map (view box.address) model