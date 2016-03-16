module Components.Text where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
import Components.System exposing (..)

view address conf currentValue = 
  let val =
    case currentValue of
      String val -> val
      _ -> ""
  in
    div [] 
      [ input 
        [ type' "text"
        , value val
        , on "input" targetValue (\str -> Signal.message address (Update str conf.path))] []
      ]
