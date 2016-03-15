module Main where

import Html exposing (..)
import StartApp.Simple as StartApp
import Counter

type Action = NoOp | TopCounter Counter.Action | BottomCounter Counter.Action

type alias Model = 
    { topCounter: Counter.Model
    , bottomCounter: Counter.Model
    }

update: Action -> Model -> Model
update action model =
    case action of 
        NoOp -> model
        TopCounter act ->
            {model | topCounter = Counter.update act model.topCounter}
        BottomCounter act ->
             {model | bottomCounter = Counter.update act model.bottomCounter}


view: Signal.Address Action -> Model -> Html
view address model =
    div [] 
        [ Counter.view (Signal.forwardTo address TopCounter) model.topCounter
        , Counter.view (Signal.forwardTo address BottomCounter) model.bottomCounter
        , text (toString model)]

init =
    { topCounter = Counter.init
    , bottomCounter = Counter.init}


main =
    StartApp.start {view = view, update = update, model = init}