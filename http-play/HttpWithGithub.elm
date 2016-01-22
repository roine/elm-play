module GetRepos where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Json exposing ((:=))
import Task exposing (Task)

type alias Repo =
  { full_name: String
  }


type alias Model =
  { searchString: String
  , repos: List Repo
  , max_items: Int
  , page: Int
  }

main =
  Signal.map (view inbox.address) model


model =
  Signal.foldp update init inbox.signal


port request: Signal (Task String ())
port request =
  Signal.map getRepos query.signal


getRepos query =
  let
    newQuery = if query == "" then Task.fail "fail" else Task.succeed (getUrl query)
    decoder = Json.list (Json.object1 Repo ("full_name" := Json.string))
    getUrl query =
      "https://api.github.com/users/" ++ query ++ "/repos?per_page=" ++ model.max_items ++ "&page=" ++ model.page
  in
    newQuery
--       `Task.andThen` (\url -> Http.get decoder (getUrl query))
      `Task.andThen` (Task.mapError (always "Not Found") << Http.get decoder)
      `Task.andThen` (\response -> Signal.send inbox.address (UpdateReposModel response))



type Action = NoOp | UpdateSearchString String | UpdateReposModel (List Repo)


update: Action -> Model -> Model
update action model =
  case action of
    NoOp -> model
    UpdateSearchString newStr -> {model | searchString = newStr }
    UpdateReposModel repos -> {model | repos = repos}


view address model =
  div []
    [ text "Choose a user on github"
    , input
      [ value model.searchString
      , on "input" targetValue (Signal.message address << UpdateSearchString)
      ] []
    , button [onClick query.address model.searchString] [text "got get it"]
    , debug model
    , ul [] (List.map prettyRepo model.repos)
    ]

prettyRepo repo =
  li [] [text repo.full_name]

debug model =
  let
    help = Debug.log (toString model)
  in
    text ((toString model) ++ " There are " ++ (toString (List.length model.repos)) ++ " items.")

init =
  { searchString = ""
  , repos = []
  , max_items = 20
  , page = 1
  }

inbox =
  Signal.mailbox NoOp

query =
  Signal.mailbox ""
