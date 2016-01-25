module RoutePlay where

import Html exposing (..)
import RouteParser as Route exposing (Matcher, static, dyn1, match)
import StartApp
import Task
import Effects
import Home
import System exposing (..)
import Users

port route: Signal String

matchers : List (Matcher Route)
matchers =
  [ static Loading "/loading"
  , static Home "/"
  , static Users "/users"
  , static UserAdd "/users/add"
  , dyn1 User "/users/" Route.int ""
  , dyn1 UserEdit "/users/" Route.int "/edit"
  ]


view: Signal.Address Action -> Model -> Html
view address model =
  let
    debugIt = Debug.log "model" model
    bind view = view address model
  in
  case (match matchers model.route) of
    Nothing -> text "404"
    Just Loading -> text "loading, be patient"
    Just Home -> Home.view (Signal.forwardTo address HomeForward) model.home
    Just Users -> Users.view (Signal.forwardTo address UsersForward) model.users
    Just UserAdd -> text "add a user"
    Just (User id) -> text ("hello user with id: " ++ (toString id))
    Just (UserEdit id) -> text ("get user" ++ (toString id))


update: Action -> Model -> (Model, Effects.Effects a)
update action model =
  case action of
    NoOp -> (model, Effects.none)
    UpdateRouteString newRoute -> ({ model | route = newRoute }, Effects.none)
    UsersForward act -> ({model | users = Users.update act model.users}, Effects.none)
    HomeForward act -> ({model | home = Home.update act model.home}, Effects.none)


updateRoute newRoute =
  match matchers newRoute

app =
  StartApp.start
  { init = (init, Effects.none)
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
  , counter = 0
  , params = {id = 0}
  , users = Users.init
  , home = Home.init
  }
