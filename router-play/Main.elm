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
    Maybe.Just Loading -> text "loading, be patient"
    Maybe.Just Home -> Home.view address model
    Maybe.Just Users -> bind Users.view
    Maybe.Just UserAdd -> text "add a user"
    Maybe.Just (User id) -> text ("hello user with id: " ++ (toString id))
    Maybe.Just (UserEdit id) -> text ("get user" ++ (toString id))


update: Action -> Model -> (Model, Effects.Effects a)
update action model =
  case action of
    NoOp -> (model, Effects.none)
    UpdateRouteString newRoute -> ({ model | route = newRoute }, Effects.none)
    Decrement -> ({model | counter = model.counter - 1}, Effects.none)
    Increment -> ({model | counter = model.counter + 1}, Effects.none)

updateRoute newRoute =
  match matchers newRoute

app =
  StartApp.start
  { init = (init, Effects.none)
  , update = update
  , view = view
  , inputs = [Signal.map UpdateRouteString route]
  }


main =
  app.html

init =
  { route = "/loading"
  , counter = 0
  , params = {id = 0}
  }
