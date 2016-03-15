module Main where

import StartApp

import RandomGifViewer exposing (view, update, init, inputs)
import Task
import Effects

app =
    StartApp.start 
        { view = view
        , update = update
        , init = init
        , inputs = inputs
    }

main =
    app.html

port tasks: Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks




