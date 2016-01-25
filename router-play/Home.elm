module Home where
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, href)
import System exposing (..)


view address model=
  div  [class "container"]
    [ button [onClick address Decrement] [text "-"]
    , text (toString model.counter)
    , button [onClick address Increment] [text "+"]
    , a [href "#!/users/15/edit"] [text "go to edit user 15"]
    ]


update action model =
    case action of
        Increment ->
            {model | counter = model.counter + 1}
        Decrement ->
            {model | counter = model.counter - 1}


init =
    { counter = 0 }