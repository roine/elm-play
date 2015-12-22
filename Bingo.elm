module Bingo where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (toUpper)
import List exposing (map)
import StartApp.Simple as StartApp


main =
  StartApp.start
  { model = initialModel,
    view = view,
    update = update
  }

view address model =
  div [class "container"]
    [ pageHeader,
      entryList address model.entries,
      button [class "sort", onClick address Sort] [text "Sort"],
      addForm address,
      pageFooter
    ]

pageHeader =
  h1 [class "header"] [text (title "Bingo!")]

addForm address =
  div [class "add-form"]
    [ input [ value initialModel.addFormString
    ][],
      button [onClick address Add][text "add new"]
    ]

pageFooter =
  footer []
    [a [href "http://google.com"]
      [ text "My Website"]
    ]

entryList address entries =
  ul [] (map (entryItem address) entries)

entryItem address entry =
  li [class ("entry-" ++ toString entry.id),
      classList [("marked", entry.wasSpoken)],
      onClick address (Mark entry.id)]
    [ span [class "phrase"] [text entry.phrase],
      span [class "points"] [text (toString entry.points)],
      span []
        [ button [class "delete", onClick address (Delete entry.id)] [text "Delete"]
        ]
    ]

title: String -> String
title string =
  string
  |> toUpper

newEntry phrase points id =
  { phrase = phrase,
    points = points,
    wasSpoken = False,
    id = id
  }

initialModel =
  { addFormString = "lol",
    entries =
    [ newEntry "jonathan" 5000 1,
      newEntry "henry" 1000 2
    ]
  }


type Action =
  NoOp
  | Sort
  | Delete Int
  | Add
  | Mark Int

update action model =
  case action of
    NoOp ->
      model
    Sort ->
      {model | entries = List.sortBy .points model.entries }
    Delete id ->
      let remainingEntries =
        List.filter (\e -> e.id /= id) model.entries
      in
        {model | entries = remainingEntries}
    Mark id ->
      let updateEntry e =
        if e.id == id then {e| wasSpoken = (not e.wasSpoken)} else e
      in
        {model | entries = List.map updateEntry model.entries}
    Add ->
      let
        newId = List.length model.entries + 1
        concatNewEntry id =
          List.append model.entries [newEntry initialModel.addFormString 1000 id]
      in
        {model | entries = concatNewEntry newId}
