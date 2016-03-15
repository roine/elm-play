module JsonExtra where

import Json.Decode.Extra as Json2 exposing ((|:))
import Json.Decode as Json exposing ((:=))
import Html exposing (..)
import Html.Attributes exposing (class)

type alias Lobby =
  { name: String }


nullLobby: Lobby
nullLobby = { name = "" }

decodeLobby: Json.Value -> Lobby
decodeLobby payload =
  case Json.decodeValue lobby payload of
    Ok val -> val
    Err msg -> nullLobby

lobby : Json.Decoder Lobby
lobby =
  Json.succeed Lobby
    |: ("name" := Json.string) 

main =
  text (toString (decodeLobby "{\"name\":\"jonathan\""))