module System where

type Route
  = Home
  | Users
  | UserAdd
  | User Int
  | UserEdit Int
  | Loading

type alias Model =
  { route: String
  , counter: Int
  , params: {id: Int}
  }

type Action = NoOp | UpdateRouteString String | Decrement | Increment
