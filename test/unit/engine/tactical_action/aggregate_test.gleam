import core/models/common.{Hit}
import core/models/hex/hex
import core/models/planetary_system.{Nebula, Supernova}
import core/models/state/tactical_action.{TacticalActionState}
import core/models/unit
import engine/tactical_action/aggregate
import engine/tactical_action/commands
import engine/tactical_action/events.{
  CombatInitiated, SystemActivated, TacticTokenSpent, UnitsMoved,
}
import engine/tactical_action/movement/context.{MovementContext}
import gleam/list
import gleam/option.{None, Some}

const game_id = "game_1"

const player_id = "alice"

const enemy_id = "bob"

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

// At distance 2 from origin() with two possible intermediate hexes:
// adjacent()=(1,-1) and alt_intermediate()=(1,0)
fn two_paths_from() {
  let assert Ok(h) = hex.new(2, -1)
  h
}

fn alt_intermediate() {
  let assert Ok(h) = hex.new(1, 0)
  h
}

fn state_with(history entries: List(#(hex.Hex, String))) {
  TacticalActionState(activation_history: entries)
}

// ── MovementContext helpers ───────────────────────────────────────────────────

fn no_context() {
  MovementContext(enemy_fleets: [], anomalies: [])
}

fn enemy_at(h: hex.Hex) {
  MovementContext(enemy_fleets: [#(h, enemy_id)], anomalies: [])
}

fn enemies_at(hexes: List(hex.Hex)) {
  MovementContext(
    enemy_fleets: list.map(hexes, fn(h) { #(h, enemy_id) }),
    anomalies: [],
  )
}

fn nebula_at(h: hex.Hex) {
  MovementContext(enemy_fleets: [], anomalies: [#(h, Nebula)])
}

fn supernova_at(h: hex.Hex) {
  MovementContext(enemy_fleets: [], anomalies: [#(h, Supernova)])
}

// ── Unit helpers ──────────────────────────────────────────────────────────────

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
    kind: unit.Fighter(capacity: 0, reference_amount: 2),
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

pub fn move_units_empty_moves_produces_no_events_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, no_context())
  assert events == []
}

pub fn move_units_emits_units_moved_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 4)]
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), units)])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, no_context())
  let assert [UnitsMoved(_, _, from: from, to: to, units: moved)] = events
  assert from == adjacent()
  assert to == origin()
  assert moved == units
}

pub fn move_units_empty_game_id_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units("", player_id, [#(adjacent(), [carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_empty_player_id_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, "", [#(adjacent(), [carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_without_activated_system_returns_error_test() {
  let state = state_with(history: [])
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), [carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_from_active_system_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(origin(), [carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_from_previously_activated_system_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id), #(adjacent(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), [carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_with_empty_units_list_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), [])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_with_structure_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), [pds()])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

// ── movement range validation ─────────────────────────────────────────────────

pub fn move_units_with_exact_movement_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), [carrier(movement: 1, capacity: 4)])])
  let assert Ok(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_with_insufficient_movement_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(far(), [carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_when_any_ship_lacks_movement_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [cruiser(movement: 2), carrier(movement: 1, capacity: 4)]
  let cmd = commands.move_units(game_id, player_id, [#(far(), units)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_all_ships_with_enough_movement_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [cruiser(movement: 2), cruiser(movement: 2)]
  let cmd = commands.move_units(game_id, player_id, [#(far(), units)])
  let assert Ok(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_fighters_not_checked_for_movement_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 4), fighter(), fighter()]
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), units)])
  let assert Ok(_) = aggregate.handle_move_units(state, cmd, no_context())
}

// ── capacity validation ───────────────────────────────────────────────────────

pub fn move_units_fighters_within_capacity_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 4), fighter(), fighter()]
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), units)])
  let assert Ok(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_fighter_exceeds_capacity_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 1), fighter(), fighter()]
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), units)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_infantry_within_capacity_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 2), infantry(), infantry()]
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), units)])
  let assert Ok(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_infantry_exceeds_capacity_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 1), infantry(), infantry()]
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), units)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_mixed_carried_within_capacity_succeeds_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 2), fighter(), infantry()]
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), units)])
  let assert Ok(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_mixed_carried_exceeds_capacity_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [carrier(movement: 1, capacity: 2), fighter(), infantry(), fighter()]
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), units)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_capacity_from_multiple_ships_adds_up_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [
    carrier(movement: 1, capacity: 2),
    carrier(movement: 1, capacity: 2),
    fighter(), fighter(), fighter(), fighter(),
  ]
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), units)])
  let assert Ok(_) = aggregate.handle_move_units(state, cmd, no_context())
}

pub fn move_units_no_capacity_for_infantry_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let units = [cruiser(movement: 2), infantry()]
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), units)])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

// ── multiple origins ──────────────────────────────────────────────────────────

pub fn move_units_from_multiple_origins_emits_one_event_per_origin_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(adjacent(), [carrier(movement: 1, capacity: 4)]),
      #(far(), [cruiser(movement: 2)]),
    ])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, no_context())
  assert list.length(events) == 2
  assert list.all(events, fn(e) {
    case e {
      UnitsMoved(_, _, _, to: to, units: _) -> to == origin()
      _ -> False
    }
  })
}

pub fn move_units_one_invalid_origin_fails_entire_command_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(adjacent(), [carrier(movement: 1, capacity: 4)]),
      #(origin(), [cruiser(movement: 2)]),
      // origin() is the activated system — invalid source
    ])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, no_context())
}

// ── blocking by enemy fleet ───────────────────────────────────────────────────

pub fn move_units_through_enemy_fleet_stops_there_and_initiates_combat_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(far(), [cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, enemy_at(adjacent()))
  let assert [
    UnitsMoved(_, _, from: from, to: blocked_at, units: _),
    CombatInitiated(_, combat_hex, attacker, defender),
  ] = events
  assert from == far()
  assert blocked_at == adjacent()
  assert combat_hex == adjacent()
  assert attacker == player_id
  assert defender == enemy_id
}

pub fn move_units_with_no_enemy_in_path_reaches_destination_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(far(), [cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, no_context())
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == origin()
}

pub fn move_units_adjacent_with_enemy_at_destination_not_blocked_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), [carrier(movement: 1, capacity: 4)])])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, enemy_at(origin()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == origin()
}

pub fn move_units_routes_around_blocked_intermediate_hex_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(two_paths_from(), [cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, enemy_at(adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == origin()
}

pub fn move_units_all_paths_blocked_initiates_combat_at_first_enemy_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(two_paths_from(), [cruiser(movement: 2)])])
  let assert Ok(events) =
    aggregate.handle_move_units(
      state,
      cmd,
      enemies_at([adjacent(), alt_intermediate()]),
    )
  let assert [
    UnitsMoved(_, _, from: from, to: blocked_at, units: _),
    CombatInitiated(_, combat_hex, attacker, defender),
  ] = events
  assert from == two_paths_from()
  assert blocked_at == adjacent()
  assert combat_hex == adjacent()
  assert attacker == player_id
  assert defender == enemy_id
}

// ── Nebula rules ──────────────────────────────────────────────────────────────

pub fn ships_in_nebula_treat_movement_as_1_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), [carrier(movement: 2, capacity: 4)])])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, nebula_at(adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == origin()
}

pub fn ships_in_nebula_cannot_reach_system_beyond_movement_1_test() {
  let state = state_with(history: [#(far(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(origin(), [carrier(movement: 2, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, nebula_at(origin()))
}

pub fn nebula_on_intermediate_hex_blocks_all_paths_returns_error_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(far(), [cruiser(movement: 2)])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, nebula_at(adjacent()))
}

pub fn nebula_on_one_path_ships_route_around_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(two_paths_from(), [cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, nebula_at(adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == origin()
}

pub fn ships_can_move_into_active_system_that_is_a_nebula_test() {
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), [carrier(movement: 1, capacity: 4)])])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, nebula_at(origin()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == origin()
}

// ── Supernova rules ───────────────────────────────────────────────────────────

pub fn ships_cannot_move_into_a_supernova_test() {
  // Supernova as the activated system — no ships may enter, even as the destination
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(adjacent(), [carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, supernova_at(origin()))
}

pub fn ships_cannot_move_through_a_supernova_test() {
  // far() to origin() only passes through adjacent() — supernova there blocks all paths
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(far(), [cruiser(movement: 2)])])
  let assert Error(_) = aggregate.handle_move_units(state, cmd, supernova_at(adjacent()))
}

pub fn ships_route_around_supernova_when_alternative_path_exists_test() {
  // two_paths_from() has two intermediates; supernova at adjacent() — routes via alt_intermediate()
  let state = state_with(history: [#(origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(two_paths_from(), [cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(state, cmd, supernova_at(adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == origin()
}
