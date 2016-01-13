module Spaceship where

import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (red, lightGrey)
import Mouse
import Keyboard
import Time
import Window

type alias Ship =
  { position: Float
  , isFiring: Bool
  , reachedLeft: Bool
  , reachedRight: Bool
  , power: Int
  }

initialShip: Ship
initialShip =
  { position = 0
  , isFiring = False
  , reachedLeft = False
  , reachedRight = False
  , power = 1
  }

view: Ship -> (Int, Int) -> Element
view ship (w, h) =
  let
  (w', h') = (toFloat w, toFloat h)
  debug = Debug.watch "position" ship.position
  in
    collage w h
      [ drawGame w' h'
      , drawShip ship h'
      , toForm (show ship)
      ]

drawGame: Float -> Float -> Form
drawGame w h =
  rect w h
  |> filled lightGrey

drawShip: Ship -> Float -> Form
drawShip ship gameHeight=
  let
    radius = shipSize ship
    paddingBottom = 3
  in
    ngon 3 radius
      |> filled red
      |> rotate (degrees 90)
      |> move ( ship.position, -(gameHeight / 2) + (radius / 2) + paddingBottom)


shipSize ship =
  30 * ((toFloat ship.power) / 10 + 1)

type Actions = NoOp | Left | Right | Fire Bool | Tick

-- UPDATE

update: Actions -> Ship -> Ship
update action ship =
  let
    width = 610
    reachedLeft = ship.position + -10 <= -660 + shipSize ship
    reachedRight = ship.position + 10 >= 660 - shipSize ship
    decrease = ship.position + -10
    increase = ship.position + 10
  in
    case action of
      NoOp -> ship
      Left ->
        if ship.reachedLeft
        then ship
        else
          { ship |
            position = decrease
          , reachedLeft = reachedLeft
          , reachedRight = reachedRight
          }
      Right ->
        if ship.reachedRight
        then ship
        else
          { ship |
            position = increase
          , reachedLeft = reachedLeft
          , reachedRight = reachedRight
          }
      Fire firing ->
        let
          newPower =
            if not firing
            then ship.power
            else ship.power + 1
        in
          {ship |
            power = newPower
          , isFiring = firing
          }
      Tick ->
        let
          nextPower =
            if ship.power <= 0 || ship.isFiring
            then ship.power
            else ship.power - 1
        in
          {ship | power = nextPower }

-- SIGNALS
inputs: Signal Actions
inputs =
  Signal.mergeMany [tick, direction, fire]

direction: Signal Actions
direction =
  let
    delta = Time.fps 60
    mapAction x =
      case x of
        -1 -> Left
        0 -> NoOp
        1 -> Right
        _ -> Debug.crash "lol:"

  in
    Signal.sampleOn delta (Signal.map mapAction (Signal.map .x Keyboard.arrows))

fire: Signal Actions
fire =
  Signal.sampleOn (Time.fps 10) (Signal.map Fire Keyboard.space)

tick: Signal Actions
tick =
  Signal.map (always Tick) (Time.fps 1)

model: Signal Ship
model =
  Signal.foldp update initialShip inputs


main =
  Signal.map2 view model Window.dimensions
