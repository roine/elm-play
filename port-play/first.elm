module First where

import Graphics.Element exposing (..)
import Html exposing (..)

type Action = NoOp | FromJs String
type alias Model = String

port handShake: Signal String


view address model =
  div[][text (toString model)]


init: Model
init =
  ""

update: Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    FromJs str ->
      str

inbox =
  Signal.mailbox NoOp

model =
  Signal.foldp update init (Signal.mergeMany [inbox.signal, (Signal.map FromJs handShake)])

main =
  Signal.map (view inbox.address) model
