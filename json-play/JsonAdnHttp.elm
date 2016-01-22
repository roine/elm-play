module JsonAndHttp where

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Task
import Effects

type alias User =
  { id: Int
  , name: String
  }

type Action
  = NoOp
  | SetUsers (List User)


type alias Model =
  { loading: Bool
  , users: List User
  }

init =
  { loading = True
  , users = []
  }


view: Signal.Address Action -> Model -> Html
view address model =
  let
    usersOrLoading =
      if not model.loading then (List.map render model.users) else [text "Loading"]
  in
    div[class "container"] usersOrLoading

render: User -> Html
render user =
  div[][text user.name]


-- porta run on application bootstrap
port request : Task.Task Http.Error ()
port request =
  getUsers
  `Task.andThen`
--     (\list -> Signal.send inbox.address (SetUsers list))
    -- is equivalent to
    (SetUsers >> Signal.send inbox.address)
  `Task.onError`
    (\error -> Signal.send inbox.address (SetUsers [{id = 1, name= (toString error)}]))


getUsers: Task.Task Http.Error (List User)
getUsers =
  Http.get users "http://jsonplaceholder.typicode.com/users"


users: Json.Decoder (List User)
users =
  Json.list
    (Json.object2 User
      ("id" := Json.int)
      ("name" := Json.string))


update: Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    SetUsers users ->
      {model| users = users, loading = False}

model: Signal Model
model =
  Signal.foldp update init inbox.signal


main: Signal Html
main =
  Signal.map (view inbox.address) model


inbox: Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp
