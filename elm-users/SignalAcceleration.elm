module Acceleration where

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

inbox =
  Signal.mailbox {text = "nope"}

mouseUp: Signal Bool
mouseUp =
  Signal.map not Mouse.isDown

view: (Int, Int) -> (Int, Int) -> Element
view (w, h) (x, y) =
  let
    side =
      if x < w // 2 && y < h // 2
        then "top left"
      else if x > w // 2 && y < h // 2
        then "top right"
      else if x < w // 2 && y > h // 2
        then "bottom left"
      else if x > w // 2 && y > h // 2
        then "bottom right"
      else "no"
    square a =
      a^2
    distance axis mouse =
      abs (mouse - (axis // 2))
    acceleration =
      square (distance w x) + square (distance h y)
        |> toFloat
        |> sqrt
        |> round
        |> toString
  in
    show (side ++ " acceleration is " ++ acceleration)

main =
  Signal.map2 view Window.dimensions Mouse.position
