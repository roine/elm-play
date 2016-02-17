module RoutePlay (..) where

import Html exposing (..)
import RouteParser as Route exposing (Matcher, static, dyn1, match)
import StartApp
import Task
import Effects exposing (Effects, Never)
import Json.Decode as Json exposing ((:=))
import Http
import Dict exposing (Dict)

import Home
import Users


type Route
    = Home
    | Users
    | UserAdd
    | User Int
    | UserEdit Int
    | Loading


type Action
    = NoOp
    | UpdateRouteString String
    | UsersForward Users.Action
    | HomeForward Home.Action
    | Receiver (Maybe (List String))

type alias Data = List String


type alias Model =
    { route : String
    , nextRoute: String
    , counter : Int
    , params : { id : Int }
    , home : Home.Model
    , usersPage : Users.Model
    , data: Data
    }


port route : Signal String
matchers : List (Matcher Route)
matchers =
    [ static Loading "/loading"
    , static Home "/"
    , static Users "/users"
    , static UserAdd "/users/add"
    , dyn1 User "/users/" Route.int ""
    , dyn1 UserEdit "/users/" Route.int "/edit"
    ]


view : Signal.Address Action -> Model -> Html
view address model =
    let
        debugIt = Debug.log "model" model

        yield route = viewFor route address model
    in
        div
            []
            [ text "header"
            , yield model.route
            , text "footer"
            ]


viewFor route address model =
    case (match matchers route) of
        Nothing ->
            text "404"

        Just Loading ->
            text "loading, be patient"

        Just Home ->
            Home.view (Signal.forwardTo address HomeForward) model.home

        Just Users ->
            Users.view (Signal.forwardTo address UsersForward) model.usersPage

        Just UserAdd ->
            text "add a user"

        Just (User id) ->
            text ("hello user with id: " ++ (toString id))

        Just (UserEdit id) ->
            text ("get user" ++ (toString id))


update : Action -> Model -> ( Model, Effects.Effects Action )
update action model =
    case action of
        NoOp ->
            ( model, Effects.none )

        UpdateRouteString newRoute ->
            bootPage newRoute model

        UsersForward act ->
            ( { model | usersPage = Users.update act model.usersPage }, Effects.none )

        HomeForward act ->
            ( { model | home = Home.update act model.home }, Effects.none )

        -- Delegate that to Users component
        Receiver maybeData ->
          ({ model | data = (Maybe.withDefault model.data maybeData), route = model.nextRoute }, Effects.none)


bootPage newRoute model =
  case (match matchers newRoute) of
    Just Users ->
      ( {model | nextRoute = newRoute, route = "/loading"}, Users.bootPage Receiver)
      
    _ ->
      ({model | route = newRoute}, Effects.none)

app =
    StartApp.start
        { init = ( init, Effects.none )
        , update = update
        , view = view
        , inputs =
            [ Signal.map UpdateRouteString route
            ]
        }


main =
    app.html


init =
    { route = "/loading"
    , nextRoute = ""
    , counter = 0
    , params = { id = 0 }
    , usersPage = Users.init
    , home = Home.init
    , data= []
    }


port tasks: Signal (Task.Task Never ())
port tasks =
    app.tasks
