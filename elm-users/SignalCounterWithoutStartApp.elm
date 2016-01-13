module NoStartApp where

import Graphics.Element exposing (show, Element)
import Html exposing (..)
import Html.Events exposing (..)
import Keyboard


type Action = Increment | Decrement | NoOp
type alias Model = Int


-- VIEW
view: Model -> Element
view model =
  div[][text (toString model)]


-- ACTIONS
modify: Signal Action
modify =
  let
    operation {x, y} =
      case x of
        -1 -> Decrement
        0 -> NoOp
        1 -> Increment
        default -> NoOp
  in
    Signal.map operation Keyboard.arrows

inputs: Signal Action
inputs =
  Signal.mergeMany [modify]

-- MODEL
init =
  0

model =
  Signal.foldp update init inputs

-- UPDATE
update: Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    Increment ->
      model + 1
    Decrement ->
      model - 1

main =
  Signal.map view model
