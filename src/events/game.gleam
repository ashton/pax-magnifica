import models/map.{type Map}
import models/player.{type Player}
import models/state.{type State}
import utils/uuid

pub opaque type GameEvent {
  GameCreated(id: String)
  PlayerJoined(game_id: String, player: Player)
  MapChosen(game_id: String, map: Map)
}

pub fn game_created() {
  GameCreated(id: uuid.new())
}

pub fn player_joined(game_id: String, player: Player) {
  PlayerJoined(game_id: game_id, player: player)
}

pub fn map_chosen(game_id: String, map: Map) {
  MapChosen(game_id: game_id, map: map)
}

pub fn event_handler(event: GameEvent, state: State) -> Result(State, String) {
  todo
}
