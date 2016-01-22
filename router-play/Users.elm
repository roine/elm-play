module Users where

import Html exposing (..)
import Html.Events exposing (onClick, on, targetValue)
import Html.Attributes exposing (class, href)
import System exposing (..)
import StartApp.Simple as StartApp

view address model =
  let debugIt = Debug.log "locale state" model
  in
    div [class "container"]
      [ text "user"
      ]
