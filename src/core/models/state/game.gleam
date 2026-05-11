import core/models/hex/hex.{type Hex}
import gleam/dict.{type Dict}

pub type GameState {
  GameState(
    id: String,
    players_ids: List(String),
    map_id: String,
    fleets: Dict(Hex, String),
  )
}
