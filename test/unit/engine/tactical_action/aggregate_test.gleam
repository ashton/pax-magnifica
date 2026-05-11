import core/models/common.{Hit}
import core/models/hex/hex
import core/models/state/tactical_action.{TacticalActionState}
import core/models/unit
import engine/tactical_action/aggregate
import engine/tactical_action/commands
import engine/tactical_action/events.{SystemActivated, TacticTokenSpent, UnitsMoved}
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

fn carrier(movement m: Int, capacity c: Int) -> unit.Unit {
  unit.ShipUnit(unit.Ship(
    name: "Carrier",
    class: unit.Major,
    cost: 3,
    combat: Hit(dice_amount: Some(1), hit_on: 9, range: None, extra_dice: None, reroll_misses: False),
    movement: m,
    abilities: [],
    kind: unit.Carrier(capacity: c),
  ))
}

fn cruiser(movement m: Int) -> unit.Unit {
  unit.ShipUnit(unit.Ship(
    name: "Cruiser",
    class: unit.Major,
    cost: 2,
    combat: Hit(dice_amount: Some(1), hit_on: 7, range: None, extra_dice: None, reroll_misses: False),
    movement: m,
    abilities: [],
    kind: unit.Cruiser(capacity: 0),
  ))
}

fn fighter() -> unit.Unit {
  unit.ShipUnit(unit.Ship(
    name: "Fighter",
    class: unit.Minor,
    cost: 1,
    combat: Hit(dice_amount: Some(1), hit_on: 9, range: None, extra_dice: None, reroll_misses: False),
    movement: 0,
    abilities: [],
    kind: unit.Fighter(reference_amount: 2),
  ))
}

fn infantry() -> unit.Unit {
  unit.GroundForce(unit.Infantry(
    name: "Infantry",
    cost: 1,
    reference_amount: 2,
    combat: Hit(dice_amount: Some(1), hit_on: 8, range: None, extra_dice: None, reroll_misses: False),
    abilities: [],
  ))
}

fn pds() -> unit.Unit {
  unit.Structure(unit.PDS(name: "PDS", abilities: []))
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

// ── MoveUnits: basic guards ───────────────────────────────────────────────────

pub fn move_units_emits_units_moved_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 4)]
  let cmd = commands.move_units(game_id, player_id, adjacent(), units)
  let assert Ok(events) = aggregate.handle_move_units(state, cmd)
  let assert [UnitsMoved(_, _, from: from, to: to, units: moved)] = events
  assert from == adjacent()
  assert to == origin()
  assert moved == units
}

pub fn move_units_empty_game_id_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units("", player_id, adjacent(), [carrier(movement: 1, capacity: 4)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_empty_player_id_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, "", adjacent(), [carrier(movement: 1, capacity: 4)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_without_activated_system_returns_error_test() {
  let state = state_with(history: [])
  let cmd = commands.move_units(game_id, player_id, adjacent(), [carrier(movement: 1, capacity: 4)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_from_active_system_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, origin(), [carrier(movement: 1, capacity: 4)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_from_previously_activated_system_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id), #(adjacent(), player_id)])
  let cmd = commands.move_units(game_id, player_id, adjacent(), [carrier(movement: 1, capacity: 4)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_with_empty_list_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, adjacent(), [])
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_with_structure_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, adjacent(), [pds()])
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

// ── movement range validation ─────────────────────────────────────────────────

pub fn move_units_with_exact_movement_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, adjacent(), [carrier(movement: 1, capacity: 4)])
  let assert Ok(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_with_insufficient_movement_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, far(), [carrier(movement: 1, capacity: 4)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_when_any_ship_lacks_movement_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [cruiser(movement: 2), carrier(movement: 1, capacity: 4)]
  let cmd = commands.move_units(game_id, player_id, far(), units)
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_all_ships_with_enough_movement_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [cruiser(movement: 2), cruiser(movement: 2)]
  let cmd = commands.move_units(game_id, player_id, far(), units)
  let assert Ok(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_fighters_not_checked_for_movement_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 4), fighter(), fighter()]
  let cmd = commands.move_units(game_id, player_id, adjacent(), units)
  let assert Ok(_) = aggregate.handle_move_units(state, cmd)
}

// ── capacity validation ───────────────────────────────────────────────────────

pub fn move_units_fighters_within_capacity_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 4), fighter(), fighter()]
  let cmd = commands.move_units(game_id, player_id, adjacent(), units)
  let assert Ok(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_fighter_exceeds_capacity_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 1), fighter(), fighter()]
  let cmd = commands.move_units(game_id, player_id, adjacent(), units)
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_infantry_within_capacity_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 2), infantry(), infantry()]
  let cmd = commands.move_units(game_id, player_id, adjacent(), units)
  let assert Ok(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_infantry_exceeds_capacity_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 1), infantry(), infantry()]
  let cmd = commands.move_units(game_id, player_id, adjacent(), units)
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_mixed_carried_within_capacity_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 2), fighter(), infantry()]
  let cmd = commands.move_units(game_id, player_id, adjacent(), units)
  let assert Ok(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_mixed_carried_exceeds_capacity_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 2), fighter(), infantry(), fighter()]
  let cmd = commands.move_units(game_id, player_id, adjacent(), units)
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_capacity_from_multiple_ships_adds_up_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [
    carrier(movement: 1, capacity: 2),
    carrier(movement: 1, capacity: 2),
    fighter(), fighter(), fighter(), fighter(),
  ]
  let cmd = commands.move_units(game_id, player_id, adjacent(), units)
  let assert Ok(_) = aggregate.handle_move_units(state, cmd)
}

pub fn move_units_no_capacity_for_infantry_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [cruiser(movement: 2), infantry()]
  let cmd = commands.move_units(game_id, player_id, adjacent(), units)
  let assert Error(_) = aggregate.handle_move_units(state, cmd)
}
