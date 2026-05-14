import core/value_objects/game
import core/value_objects/player
import engine/scoring/commands.{type ScoringCommand, AwardVictoryPoints}
import engine/scoring/events.{type ScoringEvent, PlayerScoredVictoryPoints}
import gleam/dict.{type Dict}
import gleam/option.{type Option, Some}
import gleam/result

pub type ScoreState =
  Dict(String, Int)

fn validate(command: ScoringCommand) -> Result(ScoringCommand, String) {
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

pub fn handle(command: ScoringCommand) -> Result(List(ScoringEvent), String) {
  use _ <- result.try(validate(command))
  case command {
    AwardVictoryPoints(game_id, player_id, source, amount) ->
      Ok([events.PlayerScoredVictoryPoints(game_id, player_id, source, amount)])
  }
}

pub fn apply(
  state: Option(ScoreState),
  event: ScoringEvent,
) -> Option(ScoreState) {
  case event {
    PlayerScoredVictoryPoints(_, player_id, _, amount) -> {
      let scores = option.unwrap(state, dict.new())
      let current = dict.get(scores, player_id) |> result.unwrap(0)
      Some(dict.insert(scores, player_id, current + amount))
    }
  }
}
