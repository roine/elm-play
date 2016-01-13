module Mailbox where

import Html exposing (..)
import Html.Attributes exposing(..)
import Html.Events exposing (..)
import Json.Decode


type alias Model =
  { str: String
  , language: String
  }
type Action = NoOp | ChangeLanguage String


view: Signal.Address Action -> Model -> Html
view address model =
  div[class "wrapper"]
    [ select [on "change" targetValue (\lang -> Signal.message languageChange lang)]
        [ option [value "french", selected (model.language == "french")] [text "French"]
        , option [value "spanish", selected (model.language == "spanish")][text "Spanish"]
        , option [value "italian", selected (model.language == "italian")][text "Italian"]
        , option [value "english", selected (model.language == "english")][text "English"]
        ]
    , text model.str
    , button [onClick languageChange "french"][text "French"]
    , text (toString model)
    ]

-- creates a new address that forwards to our signal passing a fixed action
languageChange: Signal.Address String
languageChange =
  Signal.forwardTo inbox.address ChangeLanguage

init: Model
init =
  { str = "Hola"
  , language = "spanish"
  }


-- handle the model modification according to our custom signal's new value and string param
update: Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      init
    ChangeLanguage str ->
      case str of
        "spanish"->
          {model |
              language = str
            , str = "Hola"
          }
        "french" ->
          {model |
              language = str
            , str = "Bonjour"
          }
        "italian" ->
          {model |
              language = str
            , str = "Hola"
          }
        "english" ->
          {model |
              language = str
            , str = "Hello"
          }
        default -> Debug.crash str


-- Create a new state that will change when our custom signal (see below) updates
model: Signal Model
model =
  Signal.foldp update init inbox.signal


{- Create a new signal, return the newly created address and signal with a default value
of NoOp
Mailboxes find their use when attaching events to DOM, for a graphic app it might be useless
-}
inbox: Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp


-- pass the address to the signal mailbox to the view and map the Signal model to the view
main =
  Signal.map (view inbox.address) model
