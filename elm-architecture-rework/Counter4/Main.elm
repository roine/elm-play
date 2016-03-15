module Main where

import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp

import Counter

type Action = AddCounter | Remove ID | Counter ID Counter.Action | Reset
type alias ID = Int

type alias Model = 
    { counters: List (ID, Counter.Model)
    , nextID: ID
    }

main =
    StartApp.start { view = view, model = init, update = update }

update action model =
    case action of
        Counter id act ->
            let
                updateCounter (currentId, currentModel) =
                    if currentId == id then
                        (currentId, Counter.update act currentModel)
                    else (currentId, currentModel)
            in
                { model | counters = List.map updateCounter model.counters }
        Remove id -> 
            { model | counters = List.filter (\(counterID, _) -> counterID /= id ) model.counters }
        Reset ->
            { model | counters = [], nextID = 0 }
        AddCounter ->
            { model | 
                counters = (model.nextID, Counter.init) :: model.counters
                , nextID = model.nextID + 1
            }

view address model =
    div [] 
        [ button [onClick address AddCounter] [text "addCounter"]
        , button [onClick address Reset] [text "reset"]
        , div [] (List.map (renderCounter address) model.counters)
        , text (toString model)
        ]

renderCounter address (id, model) =
    let
        context = 
            Counter.Context 
                (Signal.forwardTo address (Counter id)) 
                (Signal.forwardTo address (always (Remove id)))
    in
        Counter.viewWithContext context model

init =
    { counters = []
    , nextID = 0
    }