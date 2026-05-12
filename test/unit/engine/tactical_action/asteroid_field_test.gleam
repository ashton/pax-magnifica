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

pub fn ship_cannot_move_into_asteroid_field_test() {
  use <- unitest.tags(["unit", "tactical_action", "asteroid_field"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, anomalies.asteroid_field_at(h.origin()))
}

pub fn ship_cannot_move_through_asteroid_field_test() {
  use <- unitest.tags(["unit", "tactical_action", "asteroid_field"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.cruiser(movement: 2)])])
  let assert Error(_) = aggregate.handle_move_units(s, cmd, anomalies.asteroid_field_at(h.adjacent()))
}

pub fn ship_routes_around_asteroid_field_when_alternative_path_exists_test() {
  use <- unitest.tags(["unit", "tactical_action", "asteroid_field"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.two_paths_from(), [units.cruiser(movement: 2)])])
  let assert Ok(events) = aggregate.handle_move_units(s, cmd, anomalies.asteroid_field_at(h.adjacent()))
  let assert [UnitsMoved(_, _, _, to: destination, units: _)] = events
  assert destination == h.origin()
}

pub fn ship_with_antimass_deflectors_can_move_into_asteroid_field_test() {
  use <- unitest.tags(["unit", "tactical_action", "asteroid_field"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.adjacent(), [units.carrier(movement: 1, capacity: 4)])])
  let assert Ok(_) =
    aggregate.handle_move_units(s, cmd, anomalies.asteroid_field_with_deflectors_at(h.origin()))
}

pub fn ship_with_antimass_deflectors_can_move_through_asteroid_field_test() {
  use <- unitest.tags(["unit", "tactical_action", "asteroid_field"])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.move_units(game_id, player_id, [#(h.far(), [units.cruiser(movement: 2)])])
  let assert Ok(_) =
    aggregate.handle_move_units(s, cmd, anomalies.asteroid_field_with_deflectors_at(h.adjacent()))
}
