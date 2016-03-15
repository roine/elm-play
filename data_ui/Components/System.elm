module Components.System where


type Component = T Text | D Date | S Section

type alias Text =
  { type': String
  , placeholder: String
  , path: Path
  }

type alias Date = 
  { type': String
  , placeholder: String
  , path: Path
  }

type alias Section =
  { type': String
  , components: List Component
  }

type alias Path = List String 