import Html exposing (..)
import Html.Events exposing (onClick)
type Action = AddUp | AddDown | NoOp

type alias Model =
  { ups: Int
  , downs: Int
  }

view: Signal.Address Action -> Model -> Html
view address model =
  div[]
    [ text (toString model)
    , button[onClick address AddUp][text "up"]
    , button[onClick address AddDown][text "Down"]
    ]


init: Model
init = {ups = 0, downs = 0}


update: Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    AddUp ->
      { model | ups = model.ups + 1 }
    AddDown ->
      { model | downs = model.downs + 1 }


inbox: Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp


actions: Signal Action
actions =
  inbox.signal


model: Signal Model
model =
  Signal.foldp update init actions


main =
  Signal.map (view inbox.address) model
