import Html exposing(..)
import Json.Decode as Json exposing ((:=))

main =
  let
    payload = "{\"firstname\":\"jonathan\", \"lastname\": \"de montalembert\"}"
   in
     text (toString (decodeIt payload))

decodeIt str =
   Json.decodeString (Json.object2 (,)
      ("firstname" := Json.string)
      ("lastname" := Json.string)) str

