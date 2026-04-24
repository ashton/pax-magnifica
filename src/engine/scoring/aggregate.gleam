import core/value_objects/game
import core/value_objects/player
import engine/scoring/commands.{type ScoringCommand, AwardVictoryPoints}
import gleam/result

pub fn validate_command(
  command: ScoringCommand,
) -> Result(ScoringCommand, String) {
  case command {
    AwardVictoryPoints(game_id, player_id, _, amount) -> {
      use _ <- result.try(game.new_id(game_id))
      use _ <- result.try(player.new_id(player_id))
      case amount > 0 {
        True -> Ok(command)
        False -> Error("Victory point amount must be greater than zero")
      }
    }
  }
}
