module JsonArrayOfObjects where

import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Json.Decode as Json exposing ((:=))
import Debug
import Result exposing (andThen)

main =
  let
    payload = "[{\"job\": \"developer\", \"name\": \"Jonathan\"}, {\"job\": \"manager\", \"name\": \"Zhe\"}]"
    anotherPayload = "[{\"isAwesome\": false, \"deep\": {\"deeper\": \"Jon\"}}, {\"isAwesome\": true, \"deep\": {\"deeper\": \"Zhe\"}}]"
  in
    div [ class "main" ]
      [
      div [] (List.map viewHuman (resultToList (decodeThat payload))),
      div[] (List.map viewHuman'(resultDeepToList (decodeDeep anotherPayload)))
      ]


decodeThat: String -> Result String(List (String, String))
decodeThat payload =
  Json.decodeString (Json.list (Json.object2 (,) ("job" := Json.string)
  ("name" := Json.string))) payload


viewHuman : (String, String) -> Html
viewHuman (name, position) =
  div [ class "human" ]
  [ div [ class "title" ] [ text (name ++ position) ] ]

viewHuman' : (Bool, String) -> Html
viewHuman' (isAwesome, name) =
  div [ class "human", classList [("is-awesome", isAwesome)] ]
  [ div [ class "title" ] [ text (name) ] ]

decodeDeep: String -> Result String (List (Bool, String))
decodeDeep str =
  let getDeepStuff =
--   The two following lines are doing the same thing, the first line is a shortend to access deep
--       Json.at ["deep", "deeper"] Json.string
      Json.object1 identity ("deep" := (Json.object1 identity ("deeper" := Json.string)))
  in
    Json.decodeString (Json.list (Json.object2 (,) ("isAwesome" := Json.bool) getDeepStuff)) str

resultToList: Result String (List (String, String)) -> List (String, String)
resultToList result =
  case result of
    Ok values -> values
    Err err -> [("error", toString err)]



resultDeepToList: Result String (List (Bool, String)) -> List (Bool, String)
resultDeepToList result =
  case result of
    Ok values -> values
    Err err -> [(False, err)]
