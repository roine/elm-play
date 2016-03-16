module Decoding where

import Html exposing (..)
import StartApp
import Effects
import Task
import Http
import Json.Decode as Json exposing ((:=), map)
import Json.Decode.Extra as Json2 exposing ((|:), lazy)
import Dict

import Components.Text
import Components.Date
import Components.Fieldset
import Components.Grid
import Components.System exposing (..)

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
    ,  div [] (List.map (renderSection address model.report_data) model.configuration.sections)
    ]

renderSection address report_data section =
  div [] 
    [ text "section"
    , div [] (List.map (renderComponent address report_data) section.components)
    ]

getAtPath path data = 
  let 
    value = data 
    |> List.map (\d -> (d.path, d.value)) 
    |> Dict.fromList 
    |> Dict.get path
  in 
    case value of
      Just value ->  value
      Nothing -> String ""

setAtPath path data newVal =
  data 
    |> List.map (\d -> (d.path, d.value)) 
    |> Dict.fromList  
    |> Dict.insert path (String newVal)
    |> Dict.toList
    |> List.map (\(path, value) -> {path = path, value = value})



--renderComponent: Signal.Address -> ReportData -> Component -> Html.Html
renderComponent address report_data component =
  case component of
    TagsInput opts -> Components.Text.view address opts (getAtPath opts.path report_data)
    Fieldset opts -> Components.Fieldset.view address opts renderComponent report_data
    Grid opts -> Components.Grid.view address opts renderComponent report_data
    Toggle opts -> Components.Text.view address opts (getAtPath opts.path report_data)
    Text opts -> Components.Text.view address opts (getAtPath opts.path report_data)
    DatePicker opts -> Components.Date.view address opts (getAtPath opts.path report_data)
    TextArea opts -> Components.Text.view address opts (getAtPath opts.path report_data)
    RadioButtons opts -> Components.Text.view address opts (getAtPath opts.path report_data)
    Number opts -> Components.Text.view address opts (getAtPath opts.path report_data)
    Select opts -> Components.Text.view address opts (getAtPath opts.path report_data)



update action model =
  case action of 
    NoOp -> (model, Effects.none)
    Update newVal path-> 
      let d = (setAtPath path model.report_data newVal)
      in
      ({model | report_data = setAtPath path model.report_data newVal}, Effects.none)
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
    |: ("value" := Json.oneOf [map String Json.string, map Int Json.int])

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

