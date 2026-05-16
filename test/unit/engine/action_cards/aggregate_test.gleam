import core/models/state/action_cards as state
import engine/action_cards/aggregate
import engine/action_cards/commands
import engine/action_cards/events.{CardDiscarded, CardDrawn, CardPlayed}
import game/action_cards.{Bribery, EconomicInitiative}
import gleam/dict
import gleam/list
import unitest

const game_id = "game_1"

const player_id = "alice"

fn state_with_hand(hand) {
  state.ActionCardsState(
    hands: dict.from_list([#(player_id, hand)]),
    discard: [],
    pending_effects: [],
  )
}

// ── DrawCard ──────────────────────────────────────────────────────────────────

pub fn draw_card_emits_card_drawn_test() {
  use <- unitest.tags(["unit", "action_cards", "aggregate"])
  let cmd = commands.draw_card(game_id, player_id, EconomicInitiative)
  let assert Ok(evts) = aggregate.handle_draw(cmd)
  assert evts == [CardDrawn(game_id, player_id, EconomicInitiative)]
}

pub fn draw_card_empty_game_id_returns_error_test() {
  use <- unitest.tags(["unit", "action_cards", "aggregate"])
  let cmd = commands.draw_card("", player_id, EconomicInitiative)
  let assert Error(_) = aggregate.handle_draw(cmd)
}

pub fn draw_card_empty_player_id_returns_error_test() {
  use <- unitest.tags(["unit", "action_cards", "aggregate"])
  let cmd = commands.draw_card(game_id, "", EconomicInitiative)
  let assert Error(_) = aggregate.handle_draw(cmd)
}

// ── PlayCard: Economic Initiative ─────────────────────────────────────────────

pub fn play_economic_initiative_emits_played_then_discarded_test() {
  use <- unitest.tags(["unit", "action_cards", "aggregate"])
  let s = state_with_hand([EconomicInitiative])
  let cmd = commands.play_card(game_id, player_id, EconomicInitiative)
  let assert Ok(evts) = aggregate.handle_play(s, cmd)
  assert evts
    == [
      CardPlayed(game_id, player_id, EconomicInitiative),
      CardDiscarded(game_id, player_id, EconomicInitiative),
    ]
}

pub fn play_card_not_in_hand_returns_error_test() {
  use <- unitest.tags(["unit", "action_cards", "aggregate"])
  let s = state_with_hand([Bribery])
  let cmd = commands.play_card(game_id, player_id, EconomicInitiative)
  let assert Error(_) = aggregate.handle_play(s, cmd)
}

pub fn play_card_unknown_player_returns_error_test() {
  use <- unitest.tags(["unit", "action_cards", "aggregate"])
  let s = state_with_hand([EconomicInitiative])
  let cmd = commands.play_card(game_id, "ghost", EconomicInitiative)
  let assert Error(_) = aggregate.handle_play(s, cmd)
}

pub fn play_any_held_card_succeeds_test() {
  use <- unitest.tags(["unit", "action_cards", "aggregate"])
  let s = state_with_hand([Bribery])
  let cmd = commands.play_card(game_id, player_id, Bribery)
  let assert Ok([CardPlayed(_, _, Bribery), CardDiscarded(_, _, Bribery)]) =
    aggregate.handle_play(s, cmd)
}

pub fn play_card_empty_game_id_returns_error_test() {
  use <- unitest.tags(["unit", "action_cards", "aggregate"])
  let s = state_with_hand([EconomicInitiative])
  let cmd = commands.play_card("", player_id, EconomicInitiative)
  let assert Error(_) = aggregate.handle_play(s, cmd)
}

// ── DiscardCard ───────────────────────────────────────────────────────────────

pub fn discard_card_emits_card_discarded_test() {
  use <- unitest.tags(["unit", "action_cards", "aggregate"])
  let s = state_with_hand([EconomicInitiative])
  let cmd = commands.discard_card(game_id, player_id, EconomicInitiative)
  let assert Ok(evts) = aggregate.handle_discard(s, cmd)
  assert list.contains(
    evts,
    CardDiscarded(game_id, player_id, EconomicInitiative),
  )
}

pub fn discard_card_not_in_hand_returns_error_test() {
  use <- unitest.tags(["unit", "action_cards", "aggregate"])
  let s = state_with_hand([])
  let cmd = commands.discard_card(game_id, player_id, EconomicInitiative)
  let assert Error(_) = aggregate.handle_discard(s, cmd)
}
