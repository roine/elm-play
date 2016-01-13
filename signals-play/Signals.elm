module Game where

import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (..)
import Mouse
import Window
import Keyboard
import Time



main: Element
main =
   Signal.map view model

type alias Ship =
  { position: Int
  , powerLevel: Int
  , isFiring: Bool
  }

type alias Model =
  { ship: Ship
  }

type Action = Move Int

initModel: Model
initModel =
  { ship =
    { position = 0
     , powerLevel = 10
     , isFiring = False
    }
  }


update: Action -> Model -> Model
update action model =
  case action of
    Move x ->
      let
        changePosition ship =
          {ship | position = ship.position + x}
      in
      { model | ship = (changePosition model.ship)}


view: Model -> Element
view model =
  let
    (w, h) = (800, 500)
  in
  collage w h
    [ drawGame w h
    , drawShip h model]


drawGame: Float -> Float -> Form
drawGame width height =
  rect width height
  |> filled lightGrey


drawShip: Float -> Model -> Form
drawShip gameHeight model =
  let
    height = 30
    padding = 5
  in
    ngon 3 height
    |> filled red
    |> rotate ( degrees 90)
    |> move ((toFloat model.ship.position), (height / 2) - (gameHeight / 2) + padding)
