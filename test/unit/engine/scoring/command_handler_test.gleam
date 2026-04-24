import core/models/victory_point.{Custodians, Imperial, PublicObjectiveScored}
import engine/scoring/command_handler
import engine/scoring/commands
import engine/scoring/events.{PlayerScoredVictoryPoints}
import gleam/list

pub fn process_award_victory_points_emits_event_test() {
  let cmd = commands.award_victory_points("game_1", "player_1", Imperial, 1)
  let assert Ok(event) = command_handler.process(cmd) |> list.first()
  assert PlayerScoredVictoryPoints("game_1", "player_1", Imperial, 1) == event
}

pub fn process_award_victory_points_carries_source_test() {
  let cmd =
    commands.award_victory_points(
      "game_1",
      "player_1",
      PublicObjectiveScored("obj_1"),
      2,
    )
  let assert Ok(PlayerScoredVictoryPoints(_, _, source, amount)) =
    command_handler.process(cmd) |> list.first()
  assert source == PublicObjectiveScored("obj_1")
  assert amount == 2
}

pub fn process_award_victory_points_custodians_test() {
  let cmd =
    commands.award_victory_points("game_1", "player_1", Custodians, 1)
  let assert Ok(PlayerScoredVictoryPoints("game_1", "player_1", Custodians, 1)) =
    command_handler.process(cmd) |> list.first()
}
