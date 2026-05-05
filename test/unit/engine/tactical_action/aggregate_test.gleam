import core/models/common.{Hit}
import core/models/hex/hex
import core/models/state/tactical_action.{TacticalActionState}
import core/models/unit
import engine/tactical_action/aggregate
import engine/tactical_action/commands
import engine/tactical_action/events.{ShipsMoved, SystemActivated, TacticTokenSpent}
import gleam/list
import gleam/option.{None, Some}

const game_id = "game_1"

const player_id = "alice"

fn origin() {
  let assert Ok(h) = hex.new(0, 0)
  h
}

fn adjacent() {
  let assert Ok(h) = hex.new(1, -1)
  h
}

fn far() {
  let assert Ok(h) = hex.new(2, -2)
  h
}

fn state_with(history entries: List(#(hex.Hex, String))) {
  TacticalActionState(activation_history: entries)
}

fn carrier(movement m: Int) -> unit.Ship {
  unit.Ship(
    name: "Carrier",
    class: unit.Major,
    cost: 3,
    combat: Hit(dice_amount: Some(1), hit_on: 9, range: None, extra_dice: None, reroll_misses: False),
    movement: m,
    abilities: [],
    kind: unit.Carrier(capacity: 4),
  )
}

fn cruiser(movement m: Int) -> unit.Ship {
  unit.Ship(
    name: "Cruiser",
    class: unit.Major,
    cost: 2,
    combat: Hit(dice_amount: Some(1), hit_on: 7, range: None, extra_dice: None, reroll_misses: False),
    movement: m,
    abilities: [],
    kind: unit.Cruiser(capacity: 0),
  )
}

// ── ActivateSystem ────────────────────────────────────────────────────────────

pub fn activate_system_emits_system_activated_and_token_spent_test() {
  let state = state_with(history: [])
  let cmd = commands.activate_system(game_id, player_id, origin())
  let assert Ok(events) = aggregate.handle_activate(state, cmd)
  assert list.contains(events, SystemActivated(game_id, player_id, origin()))
  assert list.contains(events, TacticTokenSpent(game_id, player_id))
}

pub fn activate_system_empty_game_id_returns_error_test() {
  let state = state_with(history: [])
  let cmd = commands.activate_system("", player_id, origin())
  let assert Error(_) = aggregate.handle_activate(state, cmd)
}

pub fn activate_system_empty_player_id_returns_error_test() {
  let state = state_with(history: [])
  let cmd = commands.activate_system(game_id, "", origin())
  let assert Error(_) = aggregate.handle_activate(state, cmd)
}

pub fn activate_already_activated_system_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.activate_system(game_id, player_id, origin())
  let assert Error(_) = aggregate.handle_activate(state, cmd)
}

pub fn activate_different_system_when_one_already_activated_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.activate_system(game_id, player_id, adjacent())
  let assert Ok(_) = aggregate.handle_activate(state, cmd)
}

// ── MoveShips ─────────────────────────────────────────────────────────────────

pub fn move_ships_emits_ships_moved_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let ships = [carrier(movement: 1)]
  let cmd = commands.move_ships(game_id, player_id, adjacent(), ships)
  let assert Ok(events) = aggregate.handle_move_ships(state, cmd)
  let assert [ShipsMoved(_, _, from: from, to: to, ships: moved)] = events
  assert from == adjacent()
  assert to == origin()
  assert moved == ships
}

pub fn move_ships_empty_game_id_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_ships("", player_id, adjacent(), [carrier(movement: 1)])
  let assert Error(_) = aggregate.handle_move_ships(state, cmd)
}

pub fn move_ships_empty_player_id_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_ships(game_id, "", adjacent(), [carrier(movement: 1)])
  let assert Error(_) = aggregate.handle_move_ships(state, cmd)
}

pub fn move_ships_without_activated_system_returns_error_test() {
  let state = state_with(history: [])
  let cmd = commands.move_ships(game_id, player_id, adjacent(), [carrier(movement: 1)])
  let assert Error(_) = aggregate.handle_move_ships(state, cmd)
}

pub fn move_ships_from_active_system_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_ships(game_id, player_id, origin(), [carrier(movement: 1)])
  let assert Error(_) = aggregate.handle_move_ships(state, cmd)
}

pub fn move_ships_from_previously_activated_system_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id), #(adjacent(), player_id)])
  let cmd = commands.move_ships(game_id, player_id, adjacent(), [carrier(movement: 1)])
  let assert Error(_) = aggregate.handle_move_ships(state, cmd)
}

pub fn move_ships_with_empty_ship_list_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_ships(game_id, player_id, adjacent(), [])
  let assert Error(_) = aggregate.handle_move_ships(state, cmd)
}

// ── movement range validation ─────────────────────────────────────────────────

pub fn move_ships_with_exact_movement_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_ships(game_id, player_id, adjacent(), [carrier(movement: 1)])
  let assert Ok(_) = aggregate.handle_move_ships(state, cmd)
}

pub fn move_ships_with_more_than_enough_movement_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_ships(game_id, player_id, adjacent(), [cruiser(movement: 2)])
  let assert Ok(_) = aggregate.handle_move_ships(state, cmd)
}

pub fn move_ships_with_insufficient_movement_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_ships(game_id, player_id, far(), [carrier(movement: 1)])
  let assert Error(_) = aggregate.handle_move_ships(state, cmd)
}

pub fn move_ships_when_any_ship_lacks_movement_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let ships = [cruiser(movement: 2), carrier(movement: 1)]
  let cmd = commands.move_ships(game_id, player_id, far(), ships)
  let assert Error(_) = aggregate.handle_move_ships(state, cmd)
}

pub fn move_ships_all_with_enough_movement_to_far_system_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let ships = [cruiser(movement: 2), cruiser(movement: 2)]
  let cmd = commands.move_ships(game_id, player_id, far(), ships)
  let assert Ok(_) = aggregate.handle_move_ships(state, cmd)
}
