module SimpleTask where

import Html exposing (..)
import Time
import Task exposing (Task)
import TaskTutorial exposing (print, getCurrentTime)
import Graphics.Element exposing(show)
import Markdown
import Http


getDuration =
  getCurrentTime
    `Task.andThen` \start -> Task.succeed (fibonacci 25)
    `Task.andThen` \fib -> getCurrentTime
    `Task.andThen` \end -> Task.succeed (end - start)

fibonacci : Int -> Int
fibonacci n =
  if n <= 2 then
    1
  else
    fibonacci (n-1) + fibonacci (n-2)

port runner: Task x()
port runner =
  getDuration `Task.andThen` Signal.send inbox.address


inbox =
  Signal.mailbox 0

main =
  Signal.map show inbox.signal
