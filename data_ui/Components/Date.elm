module Components.Date where

import Html exposing (..)
import Html.Attributes exposing (..)

view address conf = 
  input [type' "date", placeholder conf.placeholder] []