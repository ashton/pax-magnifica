import core/models/state/action_cards.{PendingCardEffect} as state
import engine/action_cards/aggregate
import engine/action_cards/events.{CardDiscarded, CardDrawn, CardPlayed}
import game/action_cards.{Bribery, EconomicInitiative}
import gleam/dict
import gleam/list
import unitest

const game_id = "game_1"

const player_id = "alice"

pub fn apply_card_drawn_adds_to_hand_test() {
  use <- unitest.tags(["unit", "action_cards", "state_fold"])
  let s = state.initial()
  let s = aggregate.apply(s, CardDrawn(game_id, player_id, EconomicInitiative))
  let assert Ok(hand) = dict.get(s.hands, player_id)
  assert list.contains(hand, EconomicInitiative)
}

pub fn apply_multiple_draws_stack_in_hand_test() {
  use <- unitest.tags(["unit", "action_cards", "state_fold"])
  let s = state.initial()
  let s = aggregate.apply(s, CardDrawn(game_id, player_id, EconomicInitiative))
  let s = aggregate.apply(s, CardDrawn(game_id, player_id, Bribery))
  let assert Ok(hand) = dict.get(s.hands, player_id)
  assert list.length(hand) == 2
}

pub fn apply_card_played_does_not_change_state_test() {
  use <- unitest.tags(["unit", "action_cards", "state_fold"])
  let s = state.initial()
  let s = aggregate.apply(s, CardDrawn(game_id, player_id, EconomicInitiative))
  let played =
    aggregate.apply(s, CardPlayed(game_id, player_id, EconomicInitiative))
  assert played == s
}

pub fn apply_card_discarded_removes_from_hand_test() {
  use <- unitest.tags(["unit", "action_cards", "state_fold"])
  let s = state.initial()
  let s = aggregate.apply(s, CardDrawn(game_id, player_id, EconomicInitiative))
  let s =
    aggregate.apply(s, CardDiscarded(game_id, player_id, EconomicInitiative))
  let assert Ok(hand) = dict.get(s.hands, player_id)
  assert !list.contains(hand, EconomicInitiative)
}

pub fn apply_card_discarded_adds_to_discard_pile_test() {
  use <- unitest.tags(["unit", "action_cards", "state_fold"])
  let s = state.initial()
  let s = aggregate.apply(s, CardDrawn(game_id, player_id, EconomicInitiative))
  let s =
    aggregate.apply(s, CardDiscarded(game_id, player_id, EconomicInitiative))
  assert list.contains(s.discard, EconomicInitiative)
}

pub fn apply_card_discarded_only_removes_first_occurrence_test() {
  use <- unitest.tags(["unit", "action_cards", "state_fold"])
  let s = state.initial()
  let s = aggregate.apply(s, CardDrawn(game_id, player_id, EconomicInitiative))
  let s = aggregate.apply(s, CardDrawn(game_id, player_id, EconomicInitiative))
  let s =
    aggregate.apply(s, CardDiscarded(game_id, player_id, EconomicInitiative))
  let assert Ok(hand) = dict.get(s.hands, player_id)
  assert list.length(hand) == 1
}

// ── Effect tracking state fold ───────────────────────────────────────────────

pub fn apply_pending_effects_registered_adds_entry_test() {
  use <- unitest.tags(["unit", "action_cards", "state_fold"])
  let s = state.initial()
  let s =
    aggregate.apply(
      s,
      events.PendingEffectsRegistered(game_id, player_id, EconomicInitiative, 1),
    )
  let assert [PendingCardEffect("alice", EconomicInitiative, 1)] =
    s.pending_effects
}

pub fn apply_effect_acknowledged_decrements_remaining_test() {
  use <- unitest.tags(["unit", "action_cards", "state_fold"])
  let s = state.initial()
  let s =
    aggregate.apply(
      s,
      events.PendingEffectsRegistered(game_id, player_id, EconomicInitiative, 2),
    )
  let s =
    aggregate.apply(
      s,
      events.EffectAcknowledged(game_id, player_id, EconomicInitiative),
    )
  let assert [PendingCardEffect("alice", EconomicInitiative, 1)] =
    s.pending_effects
}

pub fn apply_card_effects_resolved_removes_entry_test() {
  use <- unitest.tags(["unit", "action_cards", "state_fold"])
  let s = state.initial()
  let s =
    aggregate.apply(
      s,
      events.PendingEffectsRegistered(game_id, player_id, EconomicInitiative, 1),
    )
  let s =
    aggregate.apply(
      s,
      events.EffectAcknowledged(game_id, player_id, EconomicInitiative),
    )
  let s =
    aggregate.apply(
      s,
      events.CardEffectsResolved(game_id, player_id, EconomicInitiative),
    )
  let assert [] = s.pending_effects
}

pub fn apply_card_effect_failed_removes_entry_test() {
  use <- unitest.tags(["unit", "action_cards", "state_fold"])
  let s = state.initial()
  let s =
    aggregate.apply(
      s,
      events.PendingEffectsRegistered(game_id, player_id, EconomicInitiative, 1),
    )
  let s =
    aggregate.apply(
      s,
      events.CardEffectFailed(
        game_id,
        player_id,
        EconomicInitiative,
        "some reason",
      ),
    )
  let assert [] = s.pending_effects
}
