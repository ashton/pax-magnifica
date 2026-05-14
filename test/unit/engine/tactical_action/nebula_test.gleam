import engine/tactical_action/aggregate
import engine/tactical_action/commands
import engine/tactical_action/events.{UnitsMoved}
import helpers/anomalies
import helpers/hex as h
import helpers/state
import helpers/units
import unitest

const game_id = "game_1"

const player_id = "alice"

pub fn ships_in_nebula_treat_movement_as_1_test() {
  use <- unitest.tags(["unit", "tactical_action", "nebula"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.adjacent(), [units.carrier(movement: 2, capacity: 4)]),
    ])
  let assert Ok(events) =
    aggregate.handle_move_units(s, cmd, anomalies.nebula_at(h.adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}

pub fn ships_in_nebula_cannot_reach_system_beyond_movement_1_test() {
  use <- unitest.tags(["unit", "tactical_action", "nebula"])
  let s = state.with_history([#(h.far(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.origin(), [units.carrier(movement: 2, capacity: 4)]),
    ])
  let assert Error(_) =
    aggregate.handle_move_units(s, cmd, anomalies.nebula_at(h.origin()))
}

pub fn nebula_on_intermediate_hex_blocks_all_paths_returns_error_test() {
  use <- unitest.tags(["unit", "tactical_action", "nebula"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.far(), [units.cruiser(movement: 2)]),
    ])
  let assert Error(_) =
    aggregate.handle_move_units(s, cmd, anomalies.nebula_at(h.adjacent()))
}

pub fn nebula_on_one_path_ships_route_around_test() {
  use <- unitest.tags(["unit", "tactical_action", "nebula"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.two_paths_from(), [units.cruiser(movement: 2)]),
    ])
  let assert Ok(events) =
    aggregate.handle_move_units(s, cmd, anomalies.nebula_at(h.adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}

pub fn ships_can_move_into_active_system_that_is_a_nebula_test() {
  use <- unitest.tags(["unit", "tactical_action", "nebula"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd =
    commands.move_units(game_id, player_id, [
      #(h.adjacent(), [units.carrier(movement: 1, capacity: 4)]),
    ])
  let assert Ok(events) =
    aggregate.handle_move_units(s, cmd, anomalies.nebula_at(h.origin()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}
