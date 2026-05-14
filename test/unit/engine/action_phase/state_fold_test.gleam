import core/models/action.{StrategicAction, TacticalAction}
import core/models/strategy.{Leadership, Trade}
import core/models/strategy_card.{StrategyCard}
import engine/action_phase/aggregate
import engine/action_phase/events.{
  ActionPhaseEnded, ActionPhaseStarted, PlayerPassed, PlayerTookAction,
  StrategyCardExhausted,
}
import gleam/list
import gleam/option.{None, Some}
import unitest

const game_id = "game_1"

fn sc(strategy) {
  StrategyCard(card: strategy, trade_goods: 0, exhausted: False)
}

pub fn apply_phase_started_sets_player_order_test() {
  use <- unitest.tags(["unit", "action_phase", "state_fold"])
  let cards = [#("alice", sc(Leadership)), #("bob", sc(Trade))]
  let event = ActionPhaseStarted(game_id, cards)
  let assert Some(state) = aggregate.apply(None, event)
  assert state.player_order == ["alice", "bob"]
}

pub fn apply_phase_started_sets_player_cards_test() {
  use <- unitest.tags(["unit", "action_phase", "state_fold"])
  let cards = [#("alice", sc(Leadership)), #("bob", sc(Trade))]
  let event = ActionPhaseStarted(game_id, cards)
  let assert Some(state) = aggregate.apply(None, event)
  assert state.player_cards == cards
}

pub fn apply_phase_started_clears_passed_and_last_player_test() {
  use <- unitest.tags(["unit", "action_phase", "state_fold"])
  let cards = [#("alice", sc(Leadership))]
  let assert Some(state) = aggregate.apply(None, ActionPhaseStarted(game_id, cards))
  assert state.passed_players == []
  assert state.last_player == None
}

pub fn apply_player_took_action_updates_last_player_test() {
  use <- unitest.tags(["unit", "action_phase", "state_fold"])
  let cards = [#("alice", sc(Leadership)), #("bob", sc(Trade))]
  let assert Some(state) = aggregate.apply(None, ActionPhaseStarted(game_id, cards))
  let assert Some(state) =
    aggregate.apply(Some(state), PlayerTookAction(game_id, "alice", TacticalAction))
  assert state.last_player == Some("alice")
}

pub fn apply_strategy_card_exhausted_marks_card_test() {
  use <- unitest.tags(["unit", "action_phase", "state_fold"])
  let cards = [#("alice", sc(Leadership)), #("bob", sc(Trade))]
  let assert Some(state) = aggregate.apply(None, ActionPhaseStarted(game_id, cards))
  let assert Some(state) =
    aggregate.apply(Some(state), StrategyCardExhausted(game_id, Leadership))
  let assert Ok(#(_, alice_card)) = list.find(state.player_cards, fn(pc) { pc.0 == "alice" })
  assert alice_card.exhausted == True
}

pub fn apply_strategy_card_exhausted_does_not_affect_other_cards_test() {
  use <- unitest.tags(["unit", "action_phase", "state_fold"])
  let cards = [#("alice", sc(Leadership)), #("bob", sc(Trade))]
  let assert Some(state) = aggregate.apply(None, ActionPhaseStarted(game_id, cards))
  let assert Some(state) =
    aggregate.apply(Some(state), StrategyCardExhausted(game_id, Leadership))
  let assert Ok(#(_, bob_card)) = list.find(state.player_cards, fn(pc) { pc.0 == "bob" })
  assert bob_card.exhausted == False
}

pub fn apply_player_passed_adds_to_passed_list_test() {
  use <- unitest.tags(["unit", "action_phase", "state_fold"])
  let cards = [#("alice", sc(Leadership)), #("bob", sc(Trade))]
  let assert Some(state) = aggregate.apply(None, ActionPhaseStarted(game_id, cards))
  let assert Some(state) =
    aggregate.apply(Some(state), PlayerPassed(game_id, "alice"))
  assert list.contains(state.passed_players, "alice")
  assert state.last_player == Some("alice")
}

pub fn apply_action_phase_ended_does_not_change_state_test() {
  use <- unitest.tags(["unit", "action_phase", "state_fold"])
  let cards = [#("alice", sc(Leadership))]
  let assert Some(state) = aggregate.apply(None, ActionPhaseStarted(game_id, cards))
  let assert Some(ended_state) =
    aggregate.apply(Some(state), ActionPhaseEnded(game_id))
  assert ended_state == state
}

pub fn apply_on_none_returns_none_for_non_starting_events_test() {
  use <- unitest.tags(["unit", "action_phase", "state_fold"])
  assert None == aggregate.apply(None, PlayerPassed(game_id, "alice"))
}

pub fn apply_strategic_action_event_updates_last_player_test() {
  use <- unitest.tags(["unit", "action_phase", "state_fold"])
  let cards = [#("alice", sc(Leadership)), #("bob", sc(Trade))]
  let assert Some(state) = aggregate.apply(None, ActionPhaseStarted(game_id, cards))
  let assert Some(state) =
    aggregate.apply(
      Some(state),
      PlayerTookAction(game_id, "alice", StrategicAction(Leadership)),
    )
  assert state.last_player == Some("alice")
}
