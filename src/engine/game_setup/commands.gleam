import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game_setup.{type GameSetupType}

pub type GameSetupCommand {
  CreateGame(game_id: String, player_count: Int, setup_type: GameSetupType)
  JoinGame(
    game_id: String,
    player_id: String,
    color: Color,
    faction: FactionIdentifier,
  )
  SetPlayerSecretObjective(
    game_id: String,
    player_id: String,
    objective_id: String,
  )
  StartGame
  //TODO Map and players setup
  //StandardDraftCommand(StandardDraftCommand)
  //MiltyDraftCommand(StandardDraftCommand)
}
