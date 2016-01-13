module Bingo (..) where

import Html exposing (..)
import Html.Attributes as Attr
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on, targetValue)
import String exposing (toUpper)
import List exposing (map)
import StartApp.Simple as StartApp
import Graphics.Element as Element
import Json.Decode as Json


type alias Entry =
    { phrase : String
    , points : Int
    , wasSpoken : Bool
    , id : Int
    }


type alias Model =
    { addFormName : String
    , addFormPoints : Int
    , latestId : Int
    , entries : List Entry
    }


main : Signal Html
main =
    StartApp.start
        { model = initialModel
        , view = view
        , update = update
        }



-- View


view : Signal.Address Action -> Model -> Html
view address model =
    div
        [ class "container" ]
        [ pageHeader
        , summary model
        , entryList address model.entries
        , button [ class "sort", onClick address Sort ] [ text "Sort" ]
        , addForm address model
        , pageFooter
        , debugger model
        ]


pageHeader : Html
pageHeader =
    h1 [ class "header" ] [ text (title "Bingo!") ]


summary : Model -> Html
summary model =
    div
        [ class "summary" ]
        [ pointsSummary model.entries
        , checkedSummary model.entries
        ]


pointsSummary : List Entry -> Html
pointsSummary entries =
    div
        [ class "points-summary" ]
        [ totalGainedPoints entries
        , text "/"
        , totalPoints entries
        ]


totalGainedPoints : List Entry -> Html
totalGainedPoints entries =
    let
        spokenEntries = List.filter .wasSpoken entries

        totalScore list = List.sum (List.map .points list)
    in
        totalScore spokenEntries
            |> toString
            |> text


totalPoints : List Entry -> Html
totalPoints entries =
    List.sum (List.map .points entries)
        |> toString
        |> text


checkedSummary : List Entry -> Html
checkedSummary entries =
    div
        [ class "checked-summary" ]
        [ totalCheckedItems entries
        , text "/"
        , totalItems entries
        ]


totalCheckedItems : List Entry -> Html
totalCheckedItems entries =
    let
        spokenEntries = List.filter .wasSpoken entries
    in
        List.length spokenEntries
            |> toString
            |> text


totalItems : List Entry -> Html
totalItems entries =
    List.length entries
        |> toString
        |> text


addForm : Signal.Address Action -> Model -> Html
addForm address model =
    let
        targetValueInt = Json.at [ "target", "valueAsNumber" ] Json.int
    in
        div
            [ class "add-form" ]
            [ input
                [ type' "text"
                , placeholder "lol"
                , value model.addFormName
                , on "input" targetValue (Signal.message address << UpdateName)
                ]
                []
            , input
                [ type' "number"
                , value (toString model.addFormPoints)
                , on "input" targetValueInt (Signal.message address << UpdatePoints)
                , Attr.maxlength 4
                ]
                []
            , button [ onClick address Add ] [ text "add new" ]
            ]


pageFooter : Html
pageFooter =
    footer
        []
        [ a
            [ href "http://google.com" ]
            [ text "My Website" ]
        ]


entryList : Signal.Address Action -> List Entry -> Html
entryList address entries =
    ul [] (map (entryItem address) entries)


entryItem : Signal.Address Action -> Entry -> Html
entryItem address entry =
    li
        [ class ("entry-" ++ toString entry.id)
        , classList [ ( "marked", entry.wasSpoken ) ]
        , onClick address (Mark entry.id)
        ]
        [ span [ class "phrase" ] [ text entry.phrase ]
        , span [ class "points" ] [ text (toString entry.points) ]
        , span
            []
            [ button [ class "delete", onClick address (Delete entry.id) ] [ text "Delete" ]
            ]
        ]


title : String -> String
title string =
    string
        |> toUpper


newEntry : String -> Int -> Int -> Entry
newEntry phrase points id =
    { phrase = phrase
    , points = points
    , wasSpoken = False
    , id = id
    }



-- Init Model


initialModel : Model
initialModel =
    { addFormName = ""
    , addFormPoints = 0
    , latestId = 3
    , entries =
        [ newEntry "jonathan" 5000 1
        , newEntry "henry" 1000 2
        , newEntry "Simone" 2000 3
        ]
    }



-- Debugger


debugger : Model -> Html
debugger model =
    div
        [ class "debugger-wrapper" ]
        [ div
            [ class "debugger" ]
            [ Html.fromElement (Element.show model) ]
        ]



-- Update


type Action
    = NoOp
    | Sort
    | Delete Int
    | Add
    | Mark Int
    | UpdateName String
    | UpdatePoints Int


update : Action -> Model -> Model
update action model =
    case action of
        NoOp ->
            model

        Sort ->
            { model | entries = List.sortBy .points model.entries }

        Delete id ->
            let
                remainingEntries =
                    List.filter (\e -> e.id /= id) model.entries
            in
                { model | entries = remainingEntries }

        Mark id ->
            let
                updateEntry e =
                    if e.id == id then
                        { e | wasSpoken = (not e.wasSpoken) }
                    else
                        e
            in
                { model | entries = List.map updateEntry model.entries }

        Add ->
            let
                newId = model.latestId + 1

                concatNewEntry id =
                    List.append model.entries [newEntry model.addFormName model.addFormPoints id]
            in
                { model
                    | entries = concatNewEntry newId
                    , addFormPoints = initialModel.addFormPoints
                    , addFormName = initialModel.addFormName
                }

        UpdateName newName ->
            { model | addFormName = newName }

        UpdatePoints newPoints ->
            { model | addFormPoints = newPoints }
