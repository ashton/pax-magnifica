import core/models/state/strategic_action.{StrategicActionState}
import core/models/strategy.{Leadership, Trade}
import engine/strategic_action/aggregate
import engine/strategic_action/commands.{
  ResolveSecondaryAbility, StartStrategicAction,
}

const game_id = "game_1"

fn started_state() {
  StrategicActionState(
    strategy: Leadership,
    initiating_player: "alice",
    secondary_order: ["bob", "charlie"],
    responded_players: [],
  )
}

// ── StartStrategicAction ──────────────────────────────────────────────────────

pub fn validate_start_valid_test() {
  let cmd =
    aggregate.start_strategic_action(game_id, "alice", Leadership, [
      "bob", "charlie",
    ])
  let assert Ok(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_empty_game_id_test() {
  let cmd = StartStrategicAction("", "alice", Leadership, ["bob"])
  let assert Error(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_empty_player_id_test() {
  let cmd = StartStrategicAction(game_id, "", Leadership, ["bob"])
  let assert Error(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_empty_secondary_order_test() {
  let cmd = StartStrategicAction(game_id, "alice", Leadership, [])
  let assert Error(_) = aggregate.validate_start(cmd)
}

// ── ResolveSecondaryAbility ───────────────────────────────────────────────────

pub fn validate_resolve_valid_test() {
  let state = started_state()
  let cmd = aggregate.resolve_secondary(game_id, "bob")
  let assert Ok(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_resolve_not_in_secondary_order_test() {
  let state = started_state()
  let cmd = aggregate.resolve_secondary(game_id, "dave")
  let assert Error(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_resolve_already_responded_test() {
  let state =
    StrategicActionState(..started_state(), responded_players: ["bob"])
  let cmd = aggregate.resolve_secondary(game_id, "bob")
  let assert Error(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_resolve_empty_ids_test() {
  let state = started_state()
  let cmd = ResolveSecondaryAbility("", "bob")
  let assert Error(_) = aggregate.validate_secondary(state, cmd)
}

// ── SkipSecondaryAbility ──────────────────────────────────────────────────────

pub fn validate_skip_valid_test() {
  let state = started_state()
  let cmd = aggregate.skip_secondary(game_id, "charlie")
  let assert Ok(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_skip_already_responded_test() {
  let state =
    StrategicActionState(..started_state(), responded_players: ["charlie"])
  let cmd = aggregate.skip_secondary(game_id, "charlie")
  let assert Error(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_skip_initiating_player_cannot_skip_test() {
  let state = started_state()
  let cmd = aggregate.skip_secondary(game_id, "alice")
  let assert Error(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_skip_wrong_strategy_type_does_not_affect_validation_test() {
  // validation is purely about who has/hasn't responded, not the card type
  let state =
    StrategicActionState(
      strategy: Trade,
      initiating_player: "alice",
      secondary_order: ["bob"],
      responded_players: [],
    )
  let cmd = aggregate.skip_secondary(game_id, "bob")
  let assert Ok(_) = aggregate.validate_secondary(state, cmd)
}
