import core/models/objective.{SecretObjective}
import core/models/victory_point.{
  Custodians, Imperial, Other, PublicObjectiveScored, SecretObjectiveScored,
}
import engine/scoring/aggregate
import engine/scoring/commands.{AwardVictoryPoints}
import engine/scoring/events.{PlayerScoredVictoryPoints}
import gleam/list

pub fn award_victory_points_returns_command_test() {
  let cmd =
    commands.award_victory_points(
      "game_1",
      "player_1",
      PublicObjectiveScored("obj_1"),
      1,
    )
  let assert AwardVictoryPoints(
    "game_1",
    "player_1",
    PublicObjectiveScored("obj_1"),
    1,
  ) = cmd
}

pub fn handle_emits_player_scored_test() {
  let cmd = commands.award_victory_points("game_1", "player_1", Imperial, 1)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(event) = list.first(events)
  assert event == PlayerScoredVictoryPoints("game_1", "player_1", Imperial, 1)
}

pub fn handle_carries_source_and_amount_test() {
  let cmd =
    commands.award_victory_points(
      "game_1",
      "player_1",
      PublicObjectiveScored("obj_1"),
      2,
    )
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(PlayerScoredVictoryPoints(_, _, source, amount)) =
    list.first(events)
  assert source == PublicObjectiveScored("obj_1")
  assert amount == 2
}

pub fn handle_custodians_test() {
  let cmd = commands.award_victory_points("game_1", "player_1", Custodians, 1)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(event) = list.first(events)
  assert event == PlayerScoredVictoryPoints("game_1", "player_1", Custodians, 1)
}

pub fn handle_empty_game_id_returns_error_test() {
  let cmd = AwardVictoryPoints("", "player_1", Imperial, 1)
  let assert Error(_) = aggregate.handle(cmd)
}

pub fn handle_empty_player_id_returns_error_test() {
  let cmd = AwardVictoryPoints("game_1", "", Imperial, 1)
  let assert Error(_) = aggregate.handle(cmd)
}

pub fn handle_zero_amount_returns_error_test() {
  let cmd = AwardVictoryPoints("game_1", "player_1", Imperial, 0)
  let assert Error(_) = aggregate.handle(cmd)
}

pub fn handle_negative_amount_returns_error_test() {
  let cmd = AwardVictoryPoints("game_1", "player_1", Imperial, -1)
  let assert Error(_) = aggregate.handle(cmd)
}

pub fn handle_accepts_all_victory_point_sources_test() {
  let sources = [
    PublicObjectiveScored("obj_1"),
    SecretObjectiveScored(SecretObjective("secret_1")),
    Imperial,
    Custodians,
    Other("special"),
  ]
  assert list.all(sources, fn(source) {
    let cmd = commands.award_victory_points("game_1", "player_1", source, 1)
    case aggregate.handle(cmd) {
      Ok(_) -> True
      Error(_) -> False
    }
  })
}
