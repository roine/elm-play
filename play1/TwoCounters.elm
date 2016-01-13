module TwoCounters where

import MyCounter
import Html exposing (..)

init =
  { top = 0
   ,bottom = 0
  }

view address model=
  div []
    [ MyCounter.view (Signal.forwardTo address Top) model.top,
      MyCounter.view (Signal.forwardTo address Bottom) model.bottom
    ]

type alias Model =
  { top: MyCounter.Model
  , bottom: MyCounter.Model
  }

type Action = Reset

update: Action -> Model
update action model =
  case action of
    Reset ->
      init
