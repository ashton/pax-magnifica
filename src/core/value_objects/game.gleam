import gleam/string

pub opaque type GameId {
  GameId(String)
}

pub fn new_id(id: String) -> Result(GameId, String) {
  case string.is_empty(id) {
    True -> Error("Game id cannot be empty")
    False -> Ok(GameId(id))
  }
}

pub fn id_value(id: GameId) -> String {
  let GameId(s) = id
  s
}
