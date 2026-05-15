import core/models/state/strategic_action.{StrategicActionState}
import core/models/strategy.{Leadership, Trade}
import engine/strategic_action/aggregate
import engine/strategic_action/commands.{
  ResolveSecondaryAbility, StartStrategicAction, resolve_secondary,
  skip_secondary, start_strategic_action,
}
import engine/strategic_action/events
import gleam/option.{None, Some}
import unitest

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
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let cmd =
    start_strategic_action(game_id, "alice", Leadership, ["bob", "charlie"])
  let assert Ok(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_empty_game_id_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let cmd = StartStrategicAction("", "alice", Leadership, ["bob"])
  let assert Error(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_empty_player_id_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let cmd = StartStrategicAction(game_id, "", Leadership, ["bob"])
  let assert Error(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_empty_secondary_order_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let cmd = StartStrategicAction(game_id, "alice", Leadership, [])
  let assert Error(_) = aggregate.validate_start(cmd)
}

// ── ResolveSecondaryAbility ───────────────────────────────────────────────────

pub fn validate_resolve_valid_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let state = started_state()
  let cmd = resolve_secondary(game_id, "bob")
  let assert Ok(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_resolve_not_in_secondary_order_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let state = started_state()
  let cmd = resolve_secondary(game_id, "dave")
  let assert Error(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_resolve_already_responded_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let state =
    StrategicActionState(..started_state(), responded_players: ["bob"])
  let cmd = resolve_secondary(game_id, "bob")
  let assert Error(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_resolve_empty_ids_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let state = started_state()
  let cmd = ResolveSecondaryAbility("", "bob")
  let assert Error(_) = aggregate.validate_secondary(state, cmd)
}

// ── SkipSecondaryAbility ──────────────────────────────────────────────────────

pub fn validate_skip_valid_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let state = started_state()
  let cmd = skip_secondary(game_id, "charlie")
  let assert Ok(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_skip_already_responded_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let state =
    StrategicActionState(..started_state(), responded_players: ["charlie"])
  let cmd = skip_secondary(game_id, "charlie")
  let assert Error(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_skip_initiating_player_cannot_skip_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let state = started_state()
  let cmd = skip_secondary(game_id, "alice")
  let assert Error(_) = aggregate.validate_secondary(state, cmd)
}

pub fn validate_skip_wrong_strategy_type_does_not_affect_validation_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  // validation is purely about who has/hasn't responded, not the card type
  let state =
    StrategicActionState(
      strategy: Trade,
      initiating_player: "alice",
      secondary_order: ["bob"],
      responded_players: [],
    )
  let cmd = skip_secondary(game_id, "bob")
  let assert Ok(_) = aggregate.validate_secondary(state, cmd)
}

// ── handle ───────────────────────────────────────────────────────────────────

pub fn handle_start_emits_strategic_action_started_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let cmd =
    start_strategic_action(game_id, "alice", Leadership, ["bob", "charlie"])
  let assert Ok([
    events.StrategicActionStarted(
      "game_1",
      "alice",
      Leadership,
      ["bob", "charlie"],
    ),
  ]) = aggregate.handle(None, cmd)
}

pub fn handle_start_invalid_returns_error_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let cmd = StartStrategicAction("", "alice", Leadership, ["bob"])
  let assert Error(_) = aggregate.handle(None, cmd)
}

pub fn handle_resolve_emits_secondary_ability_resolved_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let state = started_state()
  let cmd = resolve_secondary(game_id, "bob")
  let assert Ok([events.SecondaryAbilityResolved("game_1", "bob")]) =
    aggregate.handle(Some(state), cmd)
}

pub fn handle_skip_emits_secondary_ability_skipped_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let state = started_state()
  let cmd = skip_secondary(game_id, "charlie")
  let assert Ok([events.SecondaryAbilitySkipped("game_1", "charlie")]) =
    aggregate.handle(Some(state), cmd)
}

pub fn handle_resolve_invalid_returns_error_test() {
  use <- unitest.tags(["unit", "strategic_action", "aggregate"])
  let state = started_state()
  let cmd = resolve_secondary(game_id, "dave")
  let assert Error(_) = aggregate.handle(Some(state), cmd)
}
