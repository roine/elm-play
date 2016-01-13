import StartApp.Simple
import TwoCounters exposing (view, update, init)

main =
  StartApp.Simple.start
    { model = init,
      view = view,
      update = update
    }
