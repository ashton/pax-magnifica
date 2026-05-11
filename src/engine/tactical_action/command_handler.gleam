import core/models/state/tactical_action.{type TacticalActionState}
import engine/tactical_action/commands.{
  type TacticalActionCommand, ActivateSystem, MoveUnits,
}
import engine/tactical_action/events.{type TacticalActionEvent}
import gleam/list

pub fn process_activate(
  _state: TacticalActionState,
  command: TacticalActionCommand,
) -> List(TacticalActionEvent) {
  let assert ActivateSystem(game_id, player_id, hex) = command
  [
    events.SystemActivated(game_id, player_id, hex),
    events.TacticTokenSpent(game_id, player_id),
  ]
}

pub fn process_move_units(
  state: TacticalActionState,
  command: TacticalActionCommand,
) -> List(TacticalActionEvent) {
  let assert MoveUnits(game_id, player_id, moves) = command
  let assert Ok(#(active_hex, _)) = list.first(state.activation_history)
  list.flat_map(moves, fn(move) {
    let #(from, units) = move
    [events.UnitsMoved(game_id, player_id, from: from, to: active_hex, units: units)]
  })
}
