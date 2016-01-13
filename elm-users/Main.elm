module Users where

import Html exposing (..)
import Html.Attributes exposing(value)
import Http
import Effects
import StartApp.Simple as StartApp
import Task
import Mouse
import Signal
import Json.Decode as Json
import Html.Events exposing (on, targetValue)
import Time
import Graphics.Element exposing(..)
import Keyboard
import Char
import Window
import String

type alias Model =
  { distance: Int
  }


pixelsToKm: Int -> Element
pixelsToKm pixels =
  toFloat pixels * 0.02636
  |> toString
  |> show


model: Signal Model
model =
  Signal.foldp update initialModel Mouse.position

update: (Int, Int) -> Model -> Model
update _ model =
  {model | distance = model.distance + 1}

initialModel: Model
initialModel =
  {distance = 0}

view: Model -> Element
view model =
  pixelsToKm model.distance

main =
  Signal.map view model
