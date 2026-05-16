import core/models/state/action_cards.{ActionCardsState, PendingCardEffect} as _state
import engine/action_cards/aggregate
import engine/action_cards/commands
import engine/action_cards/events
import game/action_cards.{EconomicInitiative, Sabotage} as _cards
import gleam/dict
import unitest

const game_id = "game_1"

const player_id = "alice"

fn empty_state() {
  ActionCardsState(hands: dict.new(), discard: [], pending_effects: [])
}

fn state_with_pending(player_id: String, card, count: Int) {
  ActionCardsState(hands: dict.new(), discard: [], pending_effects: [
    PendingCardEffect(player_id, card, count),
  ])
}

// ── RegisterPendingEffects ───────────────────────────────────────────────────

pub fn register_pending_effects_emits_registered_test() {
  use <- unitest.tags(["unit", "action_cards", "effect_tracking"])
  let cmd =
    commands.RegisterPendingEffects(game_id, player_id, EconomicInitiative, 1)
  let assert Ok([
    events.PendingEffectsRegistered("game_1", "alice", EconomicInitiative, 1),
  ]) = aggregate.handle_register_effects(empty_state(), cmd)
}

pub fn register_pending_effects_rejects_zero_count_test() {
  use <- unitest.tags(["unit", "action_cards", "effect_tracking"])
  let cmd =
    commands.RegisterPendingEffects(game_id, player_id, EconomicInitiative, 0)
  let assert Error(_) = aggregate.handle_register_effects(empty_state(), cmd)
}

// ── AcknowledgeEffect ────────────────────────────────────────────────────────

pub fn acknowledge_decrements_and_resolves_when_last_test() {
  use <- unitest.tags(["unit", "action_cards", "effect_tracking"])
  let state = state_with_pending(player_id, EconomicInitiative, 1)
  let cmd = commands.AcknowledgeEffect(game_id, player_id, EconomicInitiative)
  let assert Ok([
    events.EffectAcknowledged("game_1", "alice", EconomicInitiative),
    events.CardEffectsResolved("game_1", "alice", EconomicInitiative),
  ]) = aggregate.handle_acknowledge(state, cmd)
}

pub fn acknowledge_decrements_without_resolving_when_more_remain_test() {
  use <- unitest.tags(["unit", "action_cards", "effect_tracking"])
  let state = state_with_pending(player_id, EconomicInitiative, 2)
  let cmd = commands.AcknowledgeEffect(game_id, player_id, EconomicInitiative)
  let assert Ok([
    events.EffectAcknowledged("game_1", "alice", EconomicInitiative),
  ]) = aggregate.handle_acknowledge(state, cmd)
}

pub fn acknowledge_fails_when_no_pending_effect_test() {
  use <- unitest.tags(["unit", "action_cards", "effect_tracking"])
  let cmd = commands.AcknowledgeEffect(game_id, player_id, EconomicInitiative)
  let assert Error(_) = aggregate.handle_acknowledge(empty_state(), cmd)
}

pub fn acknowledge_fails_for_wrong_card_test() {
  use <- unitest.tags(["unit", "action_cards", "effect_tracking"])
  let state = state_with_pending(player_id, EconomicInitiative, 1)
  let cmd = commands.AcknowledgeEffect(game_id, player_id, Sabotage)
  let assert Error(_) = aggregate.handle_acknowledge(state, cmd)
}

// ── EffectFailed ─────────────────────────────────────────────────────────────

pub fn effect_failed_emits_failure_event_test() {
  use <- unitest.tags(["unit", "action_cards", "effect_tracking"])
  let state = state_with_pending(player_id, EconomicInitiative, 1)
  let cmd =
    commands.EffectFailed(
      game_id,
      player_id,
      EconomicInitiative,
      "Planet not found",
    )
  let assert Ok([
    events.CardEffectFailed(
      "game_1",
      "alice",
      EconomicInitiative,
      "Planet not found",
    ),
  ]) = aggregate.handle_effect_failed(state, cmd)
}

pub fn effect_failed_when_no_pending_returns_error_test() {
  use <- unitest.tags(["unit", "action_cards", "effect_tracking"])
  let cmd =
    commands.EffectFailed(game_id, player_id, EconomicInitiative, "some reason")
  let assert Error(_) = aggregate.handle_effect_failed(empty_state(), cmd)
}
