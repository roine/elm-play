module Main (..) where

import Html exposing (div, text, Html)
import StartApp as StartApp
import Task exposing (Task)
import Effects exposing (Effects, Never)
import Json.Decode exposing (..)
import Html exposing (h2, input)
import Html.Attributes exposing (type')
import Html.Events exposing (onClick)
import Dict
import Debug


type Action
  = NoOp
  | GotData (Result String (List Datum))
  | Update Path Value


type alias Path =
  List String


type Value
  = String String
  | Int Int
  | Bool Bool


type alias Component =
  { short_name : String
  , path : Path
  }


type alias Datum =
  { path : Path
  , value : Value
  }


valueDecoder =
  Json.Decode.oneOf
    [ map Int Json.Decode.int
    , map Bool Json.Decode.bool
    , map String Json.Decode.string
    ]


pathDecoder =
  Json.Decode.list Json.Decode.string


datumDecoder =
  Json.Decode.object2
    Datum
    ("path" := pathDecoder)
    ("value" := valueDecoder)


dataDecoder =
  Json.Decode.list datumDecoder


type alias Model =
  { data : Dict.Dict Path Datum }


noFx : a -> ( a, Effects b )
noFx model =
  ( model, Effects.none )


components : List Component
components =
  [ Component "description" [ "v1_report", "adverse_event_description" ]
  , Component "company_aware" [ "v1_report", "company_aware_date" ]
  , Component "age" [ "v1_report", "age" ]
  ]


model : Model
model =
  { data = Dict.empty }


updateAtPath data path value =
  Dict.update
    path
    (\maybeDatum ->
      case maybeDatum of
        Just datum ->
          Just { datum | value = value }

        Nothing ->
          Nothing
    )
    data


doComponent value address path =
  div
    []
    [ h2
        [ onClick address (Update path (String "foo")) ]
        [ value |> toString |> text ]
    , input
        [ type' "text" ]
        []
    ]


render data address component =
  let
    component_datum =
      Dict.get component.path data
  in
    case component_datum of
      Just datum ->
        case datum.value of
          String value ->
            doComponent value address datum.path

          otherwise ->
            h2
              []
              [ text "unsupported" ]

      Nothing ->
        h2
          []
          [ text "unsupported" ]


view : Signal.Address Action -> Model -> Html
view address model =
  let
    renderWithData =
      render model.data address
  in
    div
      []
      [div [] (List.map renderWithData components)
      , text (toString model)]


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NoOp ->
      noFx model

    GotData result ->
      case result of
        Ok data ->
          let
            asDict =
              data
                |> List.map (\d -> ( d.path, d ))
                |> Dict.fromList
          in
            noFx { model | data = asDict }

        Err reason ->
          noFx model

    Update path value ->
      noFx { model | data = updateAtPath model.data path value }


app : StartApp.App Model
app =
  StartApp.start
    { init = noFx model
    , view = view
    , update = update
    , inputs = [ Signal.map GotData parsedData ]
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks


parsedData =
  Signal.map (Json.Decode.decodeValue dataDecoder) initialData


port initialData : Signal.Signal Json.Decode.Value
