module Components.Text where

import Html exposing (..)
import Html.Attributes exposing (..)

view address conf = 
  input [type' "text", placeholder conf.placeholder] []

  