module JsonSimpleObject where

import Html exposing(..)
import Json.Decode as Json exposing ((:=))

main =
  let
    payload = "{\"firstname\":\"jonathan\", \"lastname\": \"de montalembert\", \"deep\": {\"deeper\": \"that's deep\"}}"
   in
     text (toString (decodeAll payload) ++ toString (decodeFirstname payload))

decodeAll str =
   Json.decodeString (Json.object2 (,)
      ("firstname" := Json.string)
      ("lastname" := Json.string)) str

decodeFirstname str =
  Json.decodeString (Json.at ["deep", "deeper"] Json.string) str

