import core/models/state/tactical_action.{type TacticalActionState}
import engine/tactical_action/commands.{
  type TacticalActionCommand, ActivateSystem, MoveShips,
}
import engine/tactical_action/events.{type TacticalActionEvent}
import gleam/list
import gleam/result

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

pub fn process_move_ships(
  state: TacticalActionState,
  command: TacticalActionCommand,
) -> List(TacticalActionEvent) {
  let assert MoveShips(game_id, player_id, from, ships) = command
  let assert Ok(#(active_hex, _)) = list.first(state.activation_history)
  [events.ShipsMoved(game_id, player_id, from: from, to: active_hex, ships: ships)]
}
