module Decoding where

import Html exposing (..)
import StartApp
import Effects
import Task
import Http
import Json.Decode as Json exposing ((:=), map)
import Json.Decode.Extra as Json2 exposing ((|:))


type alias Model = 
  { configuration: Configuration
  }

type alias Path =
  List String

type alias Configuration =
  { path_name: String
  , short_name: String
  , label: String
  , path: Path
  , sections: List Section
  }

-- extenible record do no create a constructor, we need the construcotr for the json decode
type alias Section =
  { path_name: String
  , label: String
  , short_name: String
  , path: Path
  , template: String
  , position: Int
  , components: List Component
  }

type Component
  = Base ComponentBase
  | TagsInput ComponentTagsInput
  | Fieldset ComponentFieldset
  | Grid ComponentGrid
  | Toggle ComponentToggle
  | Text ComponentText
  | DatePicker ComponentDatePicker
  | TextArea ComponentTextArea

type alias Repository = 
  { path_name: String 
  , path: List String
  , class_name: String
  , short_name: String 
  }

type alias Validation =
  { path_name: String
  , short_name: String
  , required: Maybe Bool
  , maxlength: Maybe Int
  , format: Maybe String
  , min: Maybe Int
  , max: Maybe Int
  , scope: String
  , type': String
  }

type alias ValueLabel =
  { label: String
  , value: Bool 
  }

type alias ComponentBase =
  { path_name: String
  , short_name: String
  , path: Path
  , position: Int
  , type': String
  }

type alias ComponentFieldset = 
  { path_name: String
  , short_name: String
  , path: Path
  , position: Int
  , type': String
  , label: String
  , label_visible: Bool
  --, components: List Component
  }

type alias ComponentGrid = 
    { path_name: String
    , short_name: String
    , path: Path
    , position: Int
    , type': String
    --, components: List Component
    }

type alias ComponentToggle =
  { path_name: String
  , short_name: String
  , path: Path
  , position: Int
  , type': String
  , label_inside_input: Bool
  , repository: Repository
  , validation: Validation
  , label: String
  , label_visible: Bool
  , placeholder_label: String
  , options: List ValueLabel
  }

type alias ComponentTagsInput =
  { path_name: String
  , short_name: String
  , path: Path
  , position : Int
  , type' : String
  , label_inside_input: Bool
  , repository: Repository
  , validation: Validation
  , label: String
  , label_visible: Bool
  , placeholder_label: String
  , add_button_label: String
  }

type alias ComponentText =
  { path_name: String
  , short_name: String
  , path: Path
  , position: Int
  , type': String
  , label_inside_input: Bool
  , repository: Repository
  , validation: Validation
  , label: String
  , label_visible: Bool
  , placeholder_label: String
  }

type alias ComponentDatePicker =
  { path_name: String
  , short_name: String
  , path: Path
  , position: Int
  , type': String
  , label_inside_input: Bool
  , repository: Repository
  , validation: Validation
  , label: String
  , label_visible: Bool
  }

type alias ComponentTextArea =
  { path_name: String
  , short_name: String
  , path: Path
  , position: Int
  , type': String
  , label_inside_input: Bool
  , repository: Repository
  , validation: Validation
  , label: String
  , label_visible: Bool
  , placeholder_label: String
  }

type Action = NoOp | AddConfiguration (Maybe Configuration)

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
  (Model configurationModel, fetchConfiguration)

configurationModel =
  { path_name = "", label = "", short_name = "", path = [], sections = [] }

view address model =
  div [] 
    [ text (toString model)
    ]

update action model =
  case action of 
    NoOp -> (model, Effects.none)
    AddConfiguration conf -> ({ model | configuration = Maybe.withDefault model.configuration conf}, Effects.none)


fetchConfiguration =
  Http.get decodeConfiguration "/configuration.json"
  |> Task.toMaybe
  |> Task.map AddConfiguration
  |> Effects.task

decodeConfiguration =
  Json.succeed identity 
    |: (Json.at ["result", "configuration"]  decodeHeadConfiguration )

decodeBase f = 
  f
    |: ("path_name" := Json.string)
    |: ("short_name" := Json.string)
    |: (Json.oneOf ["label" := Json.string, Json.succeed ""])
    |: ("path" := Json.list Json.string)

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
  ("type" := Json.string) `Json.andThen` componentTypeInfo


componentTypeInfo type' =
  let d = Debug.log "matching" type'
  in
  case type' of
    "Fieldset" -> map Fieldset decodeComponentFieldset
    "TagsInput" -> map TagsInput decodeComponentTagsInput
    "Grid" -> map Grid decodeComponentGrid
    "Toggle" -> map Toggle decodeComponentToggle
    "Text" -> map Text decodeComponentText
    "DatePicker" -> map DatePicker decodeComponentDatePicker
    "TextArea" -> map TextArea decodeComponentTextArea
    _ -> map Base decodeComponentBase

decodeComponentBase =
  Json.succeed ComponentBase 
    |: ("path_name" := Json.string)
    |: ("short_name" := Json.string)
    |: ("path" := Json.list Json.string)
    |: ("position" := Json.int)
    |: ("type" := Json.string) 

decodeComponentGrid = 
  Json.succeed ComponentGrid 
    |: ("path_name" := Json.string)
    |: ("short_name" := Json.string)
    |: ("path" := Json.list Json.string)
    |: ("position" := Json.int)
    |: ("type" := Json.string) 
    --|: ("components" := Json.list decodeComponentType)

decodeComponentFieldset =
  Json.succeed ComponentFieldset
    |: ("path_name" := Json.string)
    |: ("short_name" := Json.string)
    |: ("path" := Json.list Json.string)
    |: ("position" := Json.int)
    |: ("type" := Json.string)
    |: ("label" := Json.string)
    |: ("label_visible" := Json.bool)
    --|: ("components" := Json.list decodeComponentType)

decodeComponentToggle =
  Json.succeed ComponentToggle
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
    |: ("placeholder_label" := Json.string)
    |: ("options" := Json.list (Json.object2 ValueLabel ("label" := Json.string) ("value" := Json.bool)))


decodeComponentTagsInput = 
  Json.succeed ComponentTagsInput
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
    |: ("placeholder_label" := Json.string)
    |: ("add_button_label" := Json.string)

decodeComponentText =
  Json.succeed ComponentText
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
    |: ("placeholder_label" := Json.string)

decodeComponentDatePicker =
  Json.succeed ComponentDatePicker
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

decodeComponentTextArea =
  Json.succeed ComponentTextArea
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
    |: ("placeholder_label" := Json.string)

port tasks : Signal (Task.Task Effects.Never ())
port tasks = 
  app.tasks

