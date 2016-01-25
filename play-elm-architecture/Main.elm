import Counter
import Html exposing (..)
type Action = NoOp | Reset | Top Counter.Action | Bottom Counter.Action

inbox =
  Signal.mailbox NoOp

view address model =
    div [] 
        [ Counter.view (Signal.forwardTo address Top) model.topCounter
        , Counter.view (Signal.forwardTo address Bottom) model.bottomCounter
        , text (toString model)
        ]

main =
  Signal.map (view inbox.address) model

model =
  Signal.foldp update (init 0 10) inbox.signal

update action model =
    case action of
        NoOp -> model
        Top act ->
            { model | topCounter = Counter.update act model.topCounter }
        Bottom act -> 
            { model | bottomCounter = Counter.update act model.bottomCounter }
        Reset ->
            init 0 10
    

init top bottom = 
    { topCounter = Counter.init top
    , bottomCounter  = Counter.init bottom
    }
