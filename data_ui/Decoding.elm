module Decoding where

import Html exposing (..)
import StartApp
import Effects
import Task
import Http
import Json.Decode as Json exposing ((:=), map)
import Json.Decode.Extra as Json2 exposing ((|:), lazy)

import Components.Text
import Components.Date
import Components.Fieldset
import Components.Grid
import Components.System exposing (..)

type alias Model = 
  { configuration: Configuration
  , report_data: ReportData
  }


type Action = NoOp | AddConfiguration (Maybe Model)

app = 
  StartApp.start
    { update = update
    , view = view
    , init = init
    , inputs = []
    }

main =
  app.html

init =
  (Model configurationModel [], fetchConfiguration)

configurationModel =
  { path_name = "", label = "", short_name = "", path = [], sections = [] }

view address model =
  div [] 
    [ text (toString model)
    ,  div [] (List.map (renderSection address) model.configuration.sections)
    ]

renderSection address section =
  div [] 
    [ text "section"
    , div [] (List.map (renderComponent address) section.components)
    ]

renderComponent address component =
  case component of
    TagsInput t -> Components.Text.view address t
    Fieldset t -> Components.Fieldset.view address t renderComponent
    Grid t -> Components.Grid.view address t renderComponent
    Toggle t -> Components.Text.view address t
    Text t -> Components.Text.view address t
    DatePicker t -> Components.Date.view address t
    TextArea t -> Components.Text.view address t
    RadioButtons t -> Components.Text.view address t
    Number t -> Components.Text.view address t
    Select t -> Components.Text.view address t


update action model =
  case action of 
    NoOp -> (model, Effects.none)
    AddConfiguration conf -> 
      case conf of
        Just decoded ->
          ( { model | 
                configuration = decoded.configuration, 
                report_data = decoded.report_data
            }
          , Effects.none )
        Maybe.Nothing -> (model, Effects.none)
      


fetchConfiguration =
  Http.get decodeConfiguration "/configuration.json"
  |> Task.toMaybe
  |> Task.map AddConfiguration
  |> Effects.task

decodeConfiguration =
  Json.object1 identity ("result" := 
    Json.object2 Model 
      ("configuration" := decodeHeadConfiguration)
      ("initial_data" := (Json.list decodeInitialData)))

decodeBase f = 
  f
    |: ("path_name" := Json.string)
    |: ("short_name" := Json.string)
    |: (Json.oneOf ["label" := Json.string, Json.succeed ""])
    |: ("path" := Json.list Json.string)

decodeInitialData =
  Json.succeed Datum
    |: ("path" := Json.list Json.string)
    |: ("value" := Json.string)

decodeHeadConfiguration =
  decodeBase ( Json.succeed Configuration )
    |: ("sections" := (Json.list decodeSections))

decodeRepository =
  Json.succeed Repository 
    |: ("path_name" := Json.string)
    |: ("path" := Json.list Json.string)
    |: ("class_name" := Json.string)
    |: ("short_name" := Json.string)

decodeValidation =
  Json.succeed Validation 
    |: ("path_name" := Json.string)
    |: ("short_name" := Json.string)
    |: (Json.maybe ("required" := Json.bool))
    |: (Json.maybe ("maxlength" := Json.int))
    |: (Json.maybe ("format" := Json.string))
    |: (Json.maybe ("min" := Json.int))
    |: (Json.maybe ("max" := Json.int))
    |: ("scope" := Json.string)
    |: ("type" := Json.string)

decodeSections =
  decodeBase ( Json.succeed Section )
    |: ("template" := Json.string)
    |: ("position" := Json.int)
    |: ("components" := Json.list decodeComponentType)

decodeComponentType =
  (("type" := Json.string) `Json.andThen` componentTypeInfo)

componentTypeInfo type' =
  case type' of
    "Fieldset" -> map Fieldset decodeComponentFieldset
    "TagsInput" -> map TagsInput decodeComponentTagsInput
    "Grid" -> map Grid decodeComponentGrid
    "Toggle" -> map Toggle decodeComponentToggle
    "Text" -> map Text decodeComponentText
    "DatePicker" -> map DatePicker decodeComponentDatePicker
    "TextArea" -> map TextArea decodeComponentTextArea
    "RadioButtons" -> map RadioButtons decodeComponentRadioButtons
    "Number" -> map Number decodeComponentNumber
    "Select" -> map Select decodeComponentSelect
    _ -> Json.fail ("not found: " ++ (Debug.log "fail" type'))

decodeComponentBase f =
  f
    |: ("path_name" := Json.string)
    |: ("short_name" := Json.string)
    |: ("path" := Json.list Json.string)
    |: ("position" := Json.int)
    |: ("type" := Json.string) 
    |: ("label_inside_input" := Json.bool)
    |: ("repository" := decodeRepository)
    |: ("validation" := decodeValidation)    
    |: ("label" := Json.string)
    |: ("label_visible" := Json.bool)

decodeComponentGrid = 
  Json.succeed ComponentGrid 
    |: ("path_name" := Json.string)
    |: ("short_name" := Json.string)
    |: ("path" := Json.list Json.string)
    |: ("position" := Json.int)
    |: ("type" := Json.string) 
    |: ("components" := Json.list (lazy (\_ -> decodeComponentType)))


decodeComponentFieldset =
  Json.succeed ComponentFieldset
    |: ("path_name" := Json.string)
    |: ("short_name" := Json.string)
    |: ("path" := Json.list Json.string)
    |: ("position" := Json.int)
    |: ("type" := Json.string)
    |: ("label" := Json.string)
    |: ("label_visible" := Json.bool)
    |: ("components" := Json.list (lazy (\_ -> decodeComponentType)))

decodeComponentToggle =
  decodeComponentBase (Json.succeed ComponentToggle)
    |: ("placeholder_label" := Json.string)
    |: ("options" := Json.list (Json.object2 ValueLabel ("label" := Json.string) ("value" := Json.bool)))


decodeComponentTagsInput = 
  decodeComponentBase (Json.succeed ComponentTagsInput)
    |: ("placeholder_label" := Json.string)
    |: ("add_button_label" := Json.string)

decodeComponentText =
  decodeComponentBase (Json.succeed ComponentText)
    |: ("placeholder_label" := Json.string)

decodeComponentDatePicker =
  decodeComponentBase (Json.succeed ComponentDatePicker)


decodeComponentTextArea =
  decodeComponentBase (Json.succeed ComponentTextArea)
    |: ("placeholder_label" := Json.string)

decodeComponentRadioButtons =
  decodeComponentBase (Json.succeed ComponentRadioButtons)
    |: ("placeholder_label" := Json.string)
    |: ("options" := Json.list (Json.object2 ValueLabel ("label" := Json.string) ("value" := Json.string)))

decodeComponentNumber =
  decodeComponentBase (Json.succeed ComponentNumber)
    |: ("placeholder_label" := Json.string)

decodeComponentSelect =
  decodeComponentBase (Json.succeed ComponentSelect)
    |: ("placeholder_label" := Json.string)
    |: ("default_value" := Json.string)
    |: ("options" := Json.list (Json.object2 ValueLabel ("label" := Json.string) ("value" := Json.string)))


port tasks : Signal (Task.Task Effects.Never ())
port tasks = 
  app.tasks

