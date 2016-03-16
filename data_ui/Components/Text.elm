module Components.Text where

import Html exposing (..)
import Html.Attributes exposing (..)

view address conf = 
  div [] 
    [ text conf.type'
    , input [type' "text"] []
    ]

  