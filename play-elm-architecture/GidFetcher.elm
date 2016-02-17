module GifFetcher where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Http 
import Json.Decode as Json exposing ((:=))
import Task
import StartApp
import Html.Events exposing (onClick)

type alias User = String

type alias Model =
    { users: List User
    }

type Action 
    = RequestMore
    | NewUsers (Maybe (List User))


init: (Model, Effects Action)
init  =
    (Model [], getRandomUsers)


main =
    app.html

app =
    StartApp.start 
        { init = init
        , update = update
        , view = view
        , inputs = []
        }

update: Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        RequestMore ->
            init
        NewUsers maybeUsers ->
            (Model (Maybe.withDefault model.users maybeUsers), Effects.none)

getRandomUsers: Effects Action
getRandomUsers =
    let 
        decodeUsers = Json.list (Json.object1 identity ("username" := Json.string))
    in
        Http.get decodeUsers "http://jsonplaceholder.typicode.com/users"
            |> Task.toMaybe
            |> Task.map NewUsers
            |> Effects.task

view address model =
    div [] 
        [text (toString model)
        , button [onClick address RequestMore][text "hello"]]

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks