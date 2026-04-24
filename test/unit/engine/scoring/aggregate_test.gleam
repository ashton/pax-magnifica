import core/models/objective.{SecretObjective}
import core/models/victory_point.{
  Custodians, Imperial, Other, PublicObjectiveScored, SecretObjectiveScored,
}
import engine/scoring/aggregate
import engine/scoring/commands.{AwardVictoryPoints}
import gleam/list

pub fn award_victory_points_returns_command_test() {
  let cmd =
    aggregate.award_victory_points(
      "game_1",
      "player_1",
      PublicObjectiveScored("obj_1"),
      1,
    )
  let assert AwardVictoryPoints("game_1", "player_1", PublicObjectiveScored("obj_1"), 1) =
    cmd
}

pub fn validate_award_victory_points_valid_test() {
  let cmd = aggregate.award_victory_points("game_1", "player_1", Imperial, 1)
  let assert Ok(result) = aggregate.validate_command(cmd)
  assert result == cmd
}

pub fn validate_award_victory_points_empty_game_id_test() {
  let cmd = AwardVictoryPoints("", "player_1", Imperial, 1)
  let assert Error(_) = aggregate.validate_command(cmd)
}

pub fn validate_award_victory_points_empty_player_id_test() {
  let cmd = AwardVictoryPoints("game_1", "", Imperial, 1)
  let assert Error(_) = aggregate.validate_command(cmd)
}

pub fn validate_award_victory_points_zero_amount_test() {
  let cmd = AwardVictoryPoints("game_1", "player_1", Imperial, 0)
  let assert Error(_) = aggregate.validate_command(cmd)
}

pub fn validate_award_victory_points_negative_amount_test() {
  let cmd = AwardVictoryPoints("game_1", "player_1", Imperial, -1)
  let assert Error(_) = aggregate.validate_command(cmd)
}

pub fn award_victory_points_accepts_all_sources_test() {
  let sources = [
    PublicObjectiveScored("obj_1"),
    SecretObjectiveScored(SecretObjective("secret_1")),
    Imperial,
    Custodians,
    Other("special"),
  ]
  assert list.all(sources, fn(source) {
    let cmd = aggregate.award_victory_points("game_1", "player_1", source, 1)
    case aggregate.validate_command(cmd) {
      Ok(_) -> True
      Error(_) -> False
    }
  })
}
