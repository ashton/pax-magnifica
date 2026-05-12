import engine/tactical_action/aggregate
import engine/tactical_action/commands
import engine/tactical_action/events.{
  CombatInitiated, GravityRiftEncountered, GravityRiftResolved, UnitsMoved,
}
import gleam/list
import helpers/anomalies
import helpers/context
import helpers/hex as h
import helpers/state
import helpers/units
import unitest

const game_id = "game_1"

const player_id = "alice"

// ── basic guards ──────────────────────────────────────────────────────────────

pub fn move_units_empty_moves_produces_no_events_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, context.empty())
  assert events == []
}

pub fn move_units_emits_units_moved_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let moved = [units.carrier(movement: 1, capacity: 4)]
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), moved)])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, context.empty())
  let assert [UnitsMoved(_, _, from: from, to: to, units: u)] = events
  assert from == h.adjacent()
  assert to == h.origin()
  assert u == moved
}

pub fn move_units_empty_game_id_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units("", player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_empty_player_id_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, "", [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_without_activated_system_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_from_active_system_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.origin(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_from_previously_activated_system_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id), #(h.adjacent(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_with_empty_units_list_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_with_structure_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.pds()])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

// ── movement range ────────────────────────────────────────────────────────────

pub fn move_units_with_exact_movement_succeeds_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Ok(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_with_insufficient_movement_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_when_any_ship_lacks_movement_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.cruiser(movement: 2), units.carrier(movement: 1, capacity: 4)]
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), u)])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_all_ships_with_enough_movement_succeeds_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.cruiser(movement: 2), units.cruiser(movement: 2)]
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), u)])
  let assert Ok(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_fighters_not_checked_for_movement_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.carrier(movement: 1, capacity: 4), units.fighter(), units.fighter()]
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), u)])
  let assert Ok(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

// ── capacity ──────────────────────────────────────────────────────────────────

pub fn move_units_fighters_within_capacity_succeeds_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.carrier(movement: 1, capacity: 4), units.fighter(), units.fighter()]
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), u)])
  let assert Ok(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_fighter_exceeds_capacity_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.carrier(movement: 1, capacity: 1), units.fighter(), units.fighter()]
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), u)])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_infantry_within_capacity_succeeds_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.carrier(movement: 1, capacity: 2), units.infantry(), units.infantry()]
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), u)])
  let assert Ok(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_infantry_exceeds_capacity_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.carrier(movement: 1, capacity: 1), units.infantry(), units.infantry()]
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), u)])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_mixed_carried_within_capacity_succeeds_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.carrier(movement: 1, capacity: 2), units.fighter(), units.infantry()]
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), u)])
  let assert Ok(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_mixed_carried_exceeds_capacity_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.carrier(movement: 1, capacity: 2), units.fighter(), units.infantry(), units.fighter()]
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), u)])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_capacity_from_multiple_ships_adds_up_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [
    units.carrier(movement: 1, capacity: 2),
    units.carrier(movement: 1, capacity: 2),
    units.fighter(), units.fighter(), units.fighter(), units.fighter(),
  ]
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), u)])
  let assert Ok(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

pub fn move_units_no_capacity_for_infantry_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.cruiser(movement: 2), units.infantry()]
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), u)])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

// ── multiple origins ──────────────────────────────────────────────────────────

pub fn move_units_from_multiple_origins_emits_one_event_per_origin_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.adjacent(), [units.carrier(movement: 1, capacity: 4)]),
      #(h.far(), [units.cruiser(movement: 2)]),
    ])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, context.empty())
  assert list.length(events) == 2
  assert list.all(events, fn(e) {
    case e {
      UnitsMoved(_, _, _, to: to, units: _) -> to == h.origin()
      _ -> False
    }
  })
}

pub fn move_units_one_invalid_origin_fails_entire_command_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.adjacent(), [units.carrier(movement: 1, capacity: 4)]),
      #(h.origin(), [units.cruiser(movement: 2)]),
    ])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, context.empty())
}

// ── blocking by enemy fleet ───────────────────────────────────────────────────

pub fn move_units_through_enemy_fleet_stops_there_and_initiates_combat_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, context.with_enemy_at(h.adjacent()))
  let assert [
    UnitsMoved(_, _, from: from, to: blocked_at, units: _),
    CombatInitiated(_, combat_hex, attacker, defender),
  ] = events
  assert from == h.far()
  assert blocked_at == h.adjacent()
  assert combat_hex == h.adjacent()
  assert attacker == player_id
  assert defender == context.enemy_id
}

pub fn move_units_with_no_enemy_in_path_reaches_destination_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, context.empty())
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}

pub fn move_units_adjacent_with_enemy_at_destination_not_blocked_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, context.with_enemy_at(h.origin()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}

pub fn move_units_routes_around_blocked_intermediate_hex_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.two_paths_from(), [units.cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, context.with_enemy_at(h.adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}

pub fn move_units_all_paths_blocked_initiates_combat_at_first_enemy_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.two_paths_from(), [units.cruiser(movement: 2)])])
  let assert Ok(events) =
    aggregate.handle_move_units(s, cmd, context.with_enemies_at([h.adjacent(), h.alt_intermediate()]))
  let assert [
    UnitsMoved(_, _, from: from, to: blocked_at, units: _),
    CombatInitiated(_, combat_hex, attacker, defender),
  ] = events
  assert from == h.two_paths_from()
  assert blocked_at == h.adjacent()
  assert combat_hex == h.adjacent()
  assert attacker == player_id
  assert defender == context.enemy_id
}

// ── Nebula ────────────────────────────────────────────────────────────────────

pub fn ships_in_nebula_treat_movement_as_1_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 2, capacity: 4)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, anomalies.nebula_at(h.adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}

pub fn ships_in_nebula_cannot_reach_system_beyond_movement_1_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.far(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.origin(), [units.carrier(movement: 2, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, anomalies.nebula_at(h.origin()))
}

pub fn nebula_on_intermediate_hex_blocks_all_paths_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.cruiser(movement: 2)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, anomalies.nebula_at(h.adjacent()))
}

pub fn nebula_on_one_path_ships_route_around_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.two_paths_from(), [units.cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, anomalies.nebula_at(h.adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}

pub fn ships_can_move_into_active_system_that_is_a_nebula_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, anomalies.nebula_at(h.origin()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}

// ── Gravity Rift ──────────────────────────────────────────────────────────────

pub fn gravity_rift_at_source_gives_plus1_movement_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Ok(_) = aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.far()))
}

pub fn gravity_rift_on_intermediate_gives_plus1_movement_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Ok(_) = aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.adjacent()))
}

pub fn insufficient_movement_even_with_single_rift_bonus_fails_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.three_away(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.adjacent()))
}

pub fn two_gravity_rifts_on_path_give_plus2_movement_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.three_away(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Ok(_) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rifts_at([h.far(), h.adjacent()]))
}

pub fn gravity_rift_at_destination_gives_no_movement_bonus_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Ok(_) = aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.origin()))
}

pub fn moving_out_of_gravity_rift_emits_gravity_rift_encountered_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.carrier(movement: 2, capacity: 4)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.far()))
  let assert [
    UnitsMoved(_, _, from: from, to: to, units: _),
    GravityRiftEncountered(_, _, from: rift_from, to: rift_to, rift_transits: _, dice_count: dice),
  ] = events
  assert from == h.far()
  assert to == h.origin()
  assert rift_from == h.far()
  assert rift_to == h.origin()
  assert dice == 1
}

pub fn moving_through_gravity_rift_emits_gravity_rift_encountered_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.carrier(movement: 2, capacity: 4)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.adjacent()))
  let assert [UnitsMoved(_, _, _, _, _), GravityRiftEncountered(_, _, _, _, _, dice_count: 1)] = events
}

pub fn moving_into_gravity_rift_destination_emits_no_rift_event_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.origin()))
  let assert [UnitsMoved(_, _, _, _, _)] = events
}

pub fn gravity_rift_dice_not_rolled_for_fighters_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.carrier(movement: 2, capacity: 4), units.fighter(), units.fighter()]
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), u)])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.far()))
  let assert [UnitsMoved(_, _, _, _, _), GravityRiftEncountered(_, _, _, _, _, dice_count: 1)] = events
}

pub fn gravity_rift_dice_count_equals_self_propelled_ships_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.carrier(movement: 2, capacity: 4), units.cruiser(movement: 2)]
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), u)])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.far()))
  let assert [UnitsMoved(_, _, _, _, _), GravityRiftEncountered(_, _, _, _, _, dice_count: 2)] = events
}

pub fn gravity_rift_dice_count_multiplies_by_rift_transits_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.three_away(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Ok(events) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rifts_at([h.far(), h.adjacent()]))
  let assert [UnitsMoved(_, _, _, _, _), GravityRiftEncountered(_, _, _, _, _, dice_count: 2)] = events
}

// ── Supernova ─────────────────────────────────────────────────────────────────

pub fn ships_cannot_move_into_a_supernova_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, anomalies.supernova_at(h.origin()))
}

pub fn ships_cannot_move_through_a_supernova_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.cruiser(movement: 2)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, anomalies.supernova_at(h.adjacent()))
}

pub fn ships_route_around_supernova_when_alternative_path_exists_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement", "aggregate"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.two_paths_from(), [units.cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, anomalies.supernova_at(h.adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}

// ── Gravity Rift Resolution ───────────────────────────────────────────────────

pub fn resolve_gravity_rift_without_pending_encounter_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.resolve_gravity_rift(game_id, player_id, h.far(), h.origin(), [])
  let assert Error(_) = aggregate.handle_resolve_gravity_rift(s, cmd)
}

pub fn resolve_gravity_rift_with_no_removals_emits_resolved_event_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_pending_encounter(h.far(), h.origin())
  let cmd = commands.resolve_gravity_rift(game_id, player_id, h.far(), h.origin(), [])
  let assert Ok([GravityRiftResolved(_, _, from: from, to: to, units_removed: removed)]) =
    aggregate.handle_resolve_gravity_rift(s, cmd)
  assert from == h.far()
  assert to == h.origin()
  assert removed == []
}

pub fn resolve_gravity_rift_with_removed_ship_emits_resolved_event_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_pending_encounter(h.far(), h.origin())
  let carrier = units.carrier(movement: 2, capacity: 4)
  let cmd = commands.resolve_gravity_rift(game_id, player_id, h.far(), h.origin(), [carrier])
  let assert Ok([GravityRiftResolved(_, _, _, _, units_removed: removed)]) =
    aggregate.handle_resolve_gravity_rift(s, cmd)
  assert removed == [carrier]
}

pub fn resolve_gravity_rift_with_transported_units_removed_test() {
  use <- unitest.tags(["unit", "tactical_action", "movement"])
  let s = state.with_pending_encounter(h.far(), h.origin())
  let carrier = units.carrier(movement: 2, capacity: 4)
  let f1 = units.fighter()
  let f2 = units.fighter()
  let cmd =
    commands.resolve_gravity_rift(game_id, player_id, h.far(), h.origin(), [carrier, f1, f2])
  let assert Ok([GravityRiftResolved(_, _, _, _, units_removed: removed)]) =
    aggregate.handle_resolve_gravity_rift(s, cmd)
  assert removed == [carrier, f1, f2]
}
