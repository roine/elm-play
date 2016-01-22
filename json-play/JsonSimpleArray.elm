module JsonSimpleArray where

import Html exposing (..)
import Json.Decode as Json
import Array

main =
  let
    payload = "[\"Bonjour\", \"Hi\"]"
  in
    jsonArrToList payload
      |> toString
      |> text

jsonArrToList: String -> Result String (List String)
jsonArrToList arr =
-- decodeString takes a decoder and a string to be decoded
  Json.decodeString (Json.list Json.string) arr
