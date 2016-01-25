module System where

type Route
  = Home
  | Users
  | UserAdd
  | User Int
  | UserEdit Int
  | Loading

type alias UsersState =
  { val: String
  }

type alias Page = {}

type alias Model =
  { route: String
  , counter: Int
  , params: {id: Int}
  , home: { counter : Int }
  , users: {str: String}
  }

type Action
  = NoOp
  | UpdateRouteString String
  | UsersForward UsersAction
  | HomeForward HomeAction

type UsersAction
  = DisplayLol

type HomeAction
  = Increment
  | Decrement