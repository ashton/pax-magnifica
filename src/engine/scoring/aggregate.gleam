import core/models/victory_point.{type VictoryPointSource}
import engine/scoring/commands.{type ScoringCommand, AwardVictoryPoints}
import gleam/string

pub fn award_victory_points(
  game_id: String,
  player_id: String,
  source: VictoryPointSource,
  amount: Int,
) -> ScoringCommand {
  commands.AwardVictoryPoints(game_id, player_id, source, amount)
}

pub fn validate_command(
  command: ScoringCommand,
) -> Result(ScoringCommand, String) {
  case command {
    AwardVictoryPoints(game_id, player_id, _, amount) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False ->
          case amount > 0 {
            True -> Ok(command)
            False -> Error("Victory point amount must be greater than zero")
          }
      }
  }
}
