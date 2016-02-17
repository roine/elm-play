import Counter
import Html exposing (..)
import Html.Events exposing (onClick)
type Action = NoOp | AddCounter | ActionCounter Int Counter.Action | Reset | Remove Int

type alias Model = 
    { counters: List (Int, Counter.Model)
    , nextID: ID }

type alias ID = Int

inbox =
  Signal.mailbox NoOp

view address model =
    let 
        displayCounter (id, counter) =
            div [] 
                [ Counter.view (Signal.forwardTo address (ActionCounter id)) counter
                , button[onClick address (Remove id)] [text "remove"]
                ]
    in
    div [] 
        [ button [onClick address AddCounter] [text "add counter"]
        , div [] (List.map displayCounter model.counters)
        , button [onClick address Reset] [text "reset values"]
        ]


main =
  Signal.map (view inbox.address) model

model =
  Signal.foldp update init inbox.signal

update action model =
    case action of
        NoOp -> model
        AddCounter -> { model| counters = model.counters ++ [(model.nextID, Counter.init)], nextID = model.nextID + 1 }
        ActionCounter id act -> 
           let newCounters (counterID, counter) =
                if counterID == id 
                then (id, Counter.update act counter) 
                else (counterID, counter)
            in
                {model | counters = List.map newCounters model.counters}
        Reset ->
            let newCounters (counterID, counter) =
                (counterID, Counter.init)
            in
                {model | counters = List.map newCounters model.counters}
        Remove id ->
            let newCounters (counterId, _) =
                id /= counterId
            in
                {model | counters = List.filter newCounters model.counters}


init = 
    { counters = []
    , nextID = 1
    }
