import engine/tactical_action/aggregate
import engine/tactical_action/commands
import engine/tactical_action/events.{
  GravityRiftEncountered, GravityRiftResolved, UnitsMoved,
}
import helpers/anomalies
import helpers/hex as h
import helpers/state
import helpers/units
import unitest

const game_id = "game_1"

const player_id = "alice"

// ── movement bonus ────────────────────────────────────────────────────────────

pub fn gravity_rift_at_source_gives_plus1_movement_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.far(), [units.carrier(movement: 1, capacity: 4)]),
    ])
  let assert Ok(_) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.far()))
}

pub fn gravity_rift_on_intermediate_gives_plus1_movement_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.far(), [units.carrier(movement: 1, capacity: 4)]),
    ])
  let assert Ok(_) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.adjacent()))
}

pub fn insufficient_movement_even_with_single_rift_bonus_fails_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.three_away(), [units.carrier(movement: 1, capacity: 4)]),
    ])
  let assert Error(_) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.adjacent()))
}

pub fn two_gravity_rifts_on_path_give_plus2_movement_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.three_away(), [units.carrier(movement: 1, capacity: 4)]),
    ])
  let assert Ok(_) =
    aggregate.handle_move_units(
      s,
      cmd,
      anomalies.gravity_rifts_at([h.far(), h.adjacent()]),
    )
}

pub fn gravity_rift_at_destination_gives_no_movement_bonus_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.adjacent(), [units.carrier(movement: 1, capacity: 4)]),
    ])
  let assert Ok(_) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.origin()))
}

// ── event emission ────────────────────────────────────────────────────────────

pub fn moving_out_of_gravity_rift_emits_gravity_rift_encountered_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.far(), [units.carrier(movement: 2, capacity: 4)]),
    ])
  let assert Ok(events) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.far()))
  let assert [
    UnitsMoved(_, _, from: from, to: to, units: _),
    GravityRiftEncountered(
      _,
      _,
      from: rift_from,
      to: rift_to,
      rift_transits: _,
      dice_count: dice,
    ),
  ] = events
  assert from == h.far()
  assert to == h.origin()
  assert rift_from == h.far()
  assert rift_to == h.origin()
  assert dice == 1
}

pub fn moving_through_gravity_rift_emits_gravity_rift_encountered_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.far(), [units.carrier(movement: 2, capacity: 4)]),
    ])
  let assert Ok(events) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.adjacent()))
  let assert [
    UnitsMoved(_, _, _, _, _),
    GravityRiftEncountered(_, _, _, _, _, dice_count: 1),
  ] = events
}

pub fn moving_into_gravity_rift_destination_emits_no_rift_event_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.adjacent(), [units.carrier(movement: 1, capacity: 4)]),
    ])
  let assert Ok(events) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.origin()))
  let assert [UnitsMoved(_, _, _, _, _)] = events
}

pub fn gravity_rift_dice_not_rolled_for_fighters_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [
    units.carrier(movement: 2, capacity: 4),
    units.fighter(),
    units.fighter(),
  ]
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), u)])
  let assert Ok(events) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.far()))
  let assert [
    UnitsMoved(_, _, _, _, _),
    GravityRiftEncountered(_, _, _, _, _, dice_count: 1),
  ] = events
}

pub fn gravity_rift_dice_count_equals_self_propelled_ships_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let u = [units.carrier(movement: 2, capacity: 4), units.cruiser(movement: 2)]
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), u)])
  let assert Ok(events) =
    aggregate.handle_move_units(s, cmd, anomalies.gravity_rift_at(h.far()))
  let assert [
    UnitsMoved(_, _, _, _, _),
    GravityRiftEncountered(_, _, _, _, _, dice_count: 2),
  ] = events
}

pub fn gravity_rift_dice_count_multiplies_by_rift_transits_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.three_away(), [units.carrier(movement: 1, capacity: 4)]),
    ])
  let assert Ok(events) =
    aggregate.handle_move_units(
      s,
      cmd,
      anomalies.gravity_rifts_at([h.far(), h.adjacent()]),
    )
  let assert [
    UnitsMoved(_, _, _, _, _),
    GravityRiftEncountered(_, _, _, _, _, dice_count: 2),
  ] = events
}

// ── resolution ────────────────────────────────────────────────────────────────

pub fn resolve_gravity_rift_without_pending_encounter_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.resolve_gravity_rift(game_id, player_id, h.far(), h.origin(), [])
  let assert Error(_) = aggregate.handle_resolve_gravity_rift(s, cmd)
}

pub fn resolve_gravity_rift_with_no_removals_emits_resolved_event_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_pending_encounter(h.far(), h.origin())
  let cmd =
    commands.resolve_gravity_rift(game_id, player_id, h.far(), h.origin(), [])
  let assert Ok([
    GravityRiftResolved(_, _, from: from, to: to, units_removed: removed),
  ]) = aggregate.handle_resolve_gravity_rift(s, cmd)
  assert from == h.far()
  assert to == h.origin()
  assert removed == []
}

pub fn resolve_gravity_rift_with_removed_ship_emits_resolved_event_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_pending_encounter(h.far(), h.origin())
  let carrier = units.carrier(movement: 2, capacity: 4)
  let cmd =
    commands.resolve_gravity_rift(game_id, player_id, h.far(), h.origin(), [
      carrier,
    ])
  let assert Ok([GravityRiftResolved(_, _, _, _, units_removed: removed)]) =
    aggregate.handle_resolve_gravity_rift(s, cmd)
  assert removed == [carrier]
}

pub fn resolve_gravity_rift_with_transported_units_removed_test() {
  use <- unitest.tags(["unit", "tactical_action", "gravity_rift"])
  let s = state.with_pending_encounter(h.far(), h.origin())
  let carrier = units.carrier(movement: 2, capacity: 4)
  let f1 = units.fighter()
  let f2 = units.fighter()
  let cmd =
    commands.resolve_gravity_rift(game_id, player_id, h.far(), h.origin(), [
      carrier,
      f1,
      f2,
    ])
  let assert Ok([GravityRiftResolved(_, _, _, _, units_removed: removed)]) =
    aggregate.handle_resolve_gravity_rift(s, cmd)
  assert removed == [carrier, f1, f2]
}
