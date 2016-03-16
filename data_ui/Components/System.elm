module Components.System where

type Action = NoOp | AddConfiguration (Maybe Model) | Update String Path

type alias Model = 
  { configuration: Configuration
  , report_data: ReportData
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
type Value = String String | Int Int

type alias Datum = 
  { path: Path
  , value: Value
  }

type alias ReportData =
  List Datum

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

type alias ValueLabel type' =
  { label: String
  , value: type'
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
  , components: List Component
  }

type alias ComponentGrid = 
    { path_name: String
    , short_name: String
    , path: Path
    , position: Int
    , type': String
    , components: List Component
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
  , options: List (ValueLabel Bool)
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


type alias ComponentRadioButtons =
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
  , options: List (ValueLabel String)
  }

type alias ComponentNumber =
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

type alias ComponentSelect =
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
  , default_value: String
  , options: List (ValueLabel String)
  }


type Component
  = TagsInput ComponentTagsInput
  | Fieldset ComponentFieldset
  | Grid ComponentGrid
  | Toggle ComponentToggle
  | Text ComponentText
  | DatePicker ComponentDatePicker
  | TextArea ComponentTextArea
  | RadioButtons ComponentRadioButtons
  | Number ComponentNumber
  | Select ComponentSelect

