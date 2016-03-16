module Components.Date where

import Html exposing (..)
import Html.Attributes exposing (..)

view address conf = 
  div [] 
    [ text conf.label
    , input [type' "date"] []
    ]