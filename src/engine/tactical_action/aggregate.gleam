import core/models/state/tactical_action.{type TacticalActionState}
import core/value_objects/game
import core/value_objects/player
import engine/tactical_action/activation/validation as activation
import engine/tactical_action/commands.{
  type TacticalActionCommand, ActivateSystem, MoveUnits,
}
import engine/tactical_action/events.{type TacticalActionEvent}
import engine/tactical_action/movement/context.{type MovementContext}
import engine/tactical_action/movement/validation as movement
import gleam/list
import gleam/result

pub fn handle_activate(
  state: TacticalActionState,
  command: TacticalActionCommand,
) -> Result(List(TacticalActionEvent), String) {
  let assert ActivateSystem(game_id, player_id, hex) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  use _ <- result.try(activation.not_already_activated(state, hex))
  Ok([
    events.SystemActivated(game_id, player_id, hex),
    events.TacticTokenSpent(game_id, player_id),
  ])
}

pub fn handle_move_units(
  state: TacticalActionState,
  command: TacticalActionCommand,
  ctx: MovementContext,
) -> Result(List(TacticalActionEvent), String) {
  let assert MoveUnits(game_id, player_id, moves) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  use active_hex <- result.try(activation.active_system(state))
  use events_per_move <- result.try(list.try_map(moves, fn(move) {
    let #(from, units) = move
    use _ <- result.try(activation.valid_movement_source(state, from, active_hex))
    use _ <- result.try(movement.not_empty(units))
    use _ <- result.try(movement.no_structures(units))
    use _ <- result.try(movement.capacity(units))
    use outcome <- result.try(movement.resolve_path(
      from,
      active_hex,
      units,
      ctx.enemy_fleets,
      ctx.anomalies,
    ))
    case outcome {
      movement.ReachDestination(to) ->
        Ok([events.UnitsMoved(game_id, player_id, from: from, to: to, units: units)])
      movement.BlockedAt(blocked_at, enemy_player_id) ->
        Ok([
          events.UnitsMoved(game_id, player_id, from: from, to: blocked_at, units: units),
          events.CombatInitiated(game_id, blocked_at, player_id, enemy_player_id),
        ])
    }
  }))
  Ok(list.flatten(events_per_move))
}
