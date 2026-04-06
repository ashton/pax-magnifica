import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game_setup.{type GameSetupType}
import engine/game_setup/commands
import utils/uuid

pub fn create_game(player_count: Int, setup_type: GameSetupType) {
  commands.CreateGame(uuid.new(), player_count, setup_type)
}

pub fn join_game(
  game_id: String,
  player_id: String,
  color: Color,
  faction: FactionIdentifier,
) {
  commands.JoinGame(game_id, player_id, color, faction)
}
