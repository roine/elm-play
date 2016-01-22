module SimpleSignal where

import Html exposing (div, input, text)
import Html.Events exposing (on, targetValue)

view: Signal.Address String -> String -> Html.Html
view address lastName =
  div []
    [ div [] [input[on "input" targetValue (\v -> Signal.message address v)][]],
      div [] [text (" Chris" ++ lastName)]
    ]

inbox: Signal.Mailbox String
inbox =
  Signal.mailbox ""

main =
  Signal.map (view inbox.address) inbox.signal
