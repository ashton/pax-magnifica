import engine/scoring/events.{type ScoringEvent, PlayerScoredVictoryPoints}
import gleam/dict.{type Dict}
import gleam/option.{type Option, Some}
import gleam/result

pub type ScoreState =
  Dict(String, Int)

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
