module Second where

import Html exposing (..)
import Html.Events exposing (..)

type alias Model = String


-- View

view: Signal.Address String -> Model -> Html
view address model =
  div[]
    [ text "Hello World"
    , input [on "input" targetValue (\v -> Signal.message address v)][]
    ]


-- Ports

port isActive: Signal String
port isActive = inbox.signal

-- Model

init: Model
init =
  ""


update str model=
  str


-- Signal

inbox =
  Signal.mailbox ""


model =
  Signal.foldp update init inbox.signal


main =
  Signal.map (view inbox.address) model
