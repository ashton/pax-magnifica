import core/models/victory_point.{Custodians, Imperial, PublicObjectiveScored}
import engine/scoring/aggregate
import engine/scoring/events.{PlayerScoredVictoryPoints}
import gleam/dict
import gleam/option.{None, Some}
import unitest

pub fn apply_player_scored_initialises_score_test() {
  use <- unitest.tags(["unit", "scoring", "state_fold"])
  let event = PlayerScoredVictoryPoints("game_1", "player_1", Imperial, 1)
  let assert Some(scores) = aggregate.apply(None, event)
  let assert Ok(vp) = dict.get(scores, "player_1")
  assert vp == 1
}

pub fn apply_player_scored_accumulates_points_test() {
  use <- unitest.tags(["unit", "scoring", "state_fold"])
  let state =
    Some(dict.from_list([#("player_1", 2)]))
  let event = PlayerScoredVictoryPoints("game_1", "player_1", Imperial, 3)
  let assert Some(scores) = aggregate.apply(state, event)
  let assert Ok(vp) = dict.get(scores, "player_1")
  assert vp == 5
}

pub fn apply_player_scored_tracks_multiple_players_test() {
  use <- unitest.tags(["unit", "scoring", "state_fold"])
  let state = Some(dict.from_list([#("player_1", 3)]))
  let event =
    PlayerScoredVictoryPoints("game_1", "player_2", PublicObjectiveScored("obj_1"), 2)
  let assert Some(scores) = aggregate.apply(state, event)
  let assert Ok(p1) = dict.get(scores, "player_1")
  let assert Ok(p2) = dict.get(scores, "player_2")
  assert p1 == 3
  assert p2 == 2
}

pub fn apply_player_scored_custodians_worth_one_test() {
  use <- unitest.tags(["unit", "scoring", "state_fold"])
  let event = PlayerScoredVictoryPoints("game_1", "player_1", Custodians, 1)
  let assert Some(scores) = aggregate.apply(None, event)
  let assert Ok(vp) = dict.get(scores, "player_1")
  assert vp == 1
}
