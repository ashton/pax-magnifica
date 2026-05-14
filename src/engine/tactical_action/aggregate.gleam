import core/models/hex/hex.{type Hex}
import core/models/state/tactical_action.{
  type TacticalActionState, TacticalActionState,
}
import core/models/unit
import core/value_objects/game
import core/value_objects/player
import engine/tactical_action/activation/validation as activation
import engine/tactical_action/commands.{
  type TacticalActionCommand, ActivateSystem, MoveUnits, ResolveGravityRift,
}
import engine/tactical_action/events.{
  type TacticalActionEvent, CombatInitiated, GravityRiftEncountered,
  GravityRiftResolved, SystemActivated, TacticTokenSpent, UnitsMoved,
}
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
  use events_per_move <- result.try(
    list.try_map(moves, fn(move) {
      let #(from, units) = move
      use _ <- result.try(activation.valid_movement_source(
        state,
        from,
        active_hex,
      ))
      use _ <- result.try(movement.not_empty(units))
      use _ <- result.try(movement.no_structures(units))
      use _ <- result.try(movement.capacity(units))
      use outcome <- result.try(movement.resolve_path(
        from,
        active_hex,
        units,
        ctx.enemy_fleets,
        ctx.anomalies,
        ctx.player_technologies,
      ))
      case outcome {
        movement.ReachDestination(to) -> {
          let rift_evts =
            rift_encountered_events(
              game_id,
              player_id,
              from,
              to,
              units,
              ctx.anomalies,
            )
          Ok([
            events.UnitsMoved(
              game_id,
              player_id,
              from: from,
              to: to,
              units: units,
            ),
            ..rift_evts
          ])
        }
        movement.BlockedAt(blocked_at, enemy_player_id) -> {
          let rift_evts =
            rift_encountered_events(
              game_id,
              player_id,
              from,
              blocked_at,
              units,
              ctx.anomalies,
            )
          Ok(
            list.flatten([
              [
                events.UnitsMoved(
                  game_id,
                  player_id,
                  from: from,
                  to: blocked_at,
                  units: units,
                ),
              ],
              rift_evts,
              [
                events.CombatInitiated(
                  game_id,
                  blocked_at,
                  player_id,
                  enemy_player_id,
                ),
              ],
            ]),
          )
        }
      }
    }),
  )
  Ok(list.flatten(events_per_move))
}

pub fn handle_resolve_gravity_rift(
  state: TacticalActionState,
  command: TacticalActionCommand,
) -> Result(List(TacticalActionEvent), String) {
  let assert ResolveGravityRift(game_id, player_id, from, to, units_removed) =
    command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  use _ <- result.try(
    case list.any(state.pending_rift_encounters, fn(e) { e == #(from, to) }) {
      True -> Ok(Nil)
      False -> Error("No pending gravity rift encounter for this from/to pair")
    },
  )
  Ok([events.GravityRiftResolved(game_id, player_id, from, to, units_removed)])
}

fn rift_encountered_events(
  game_id: String,
  player_id: String,
  from,
  to,
  units: List(unit.Unit),
  anomalies,
) -> List(TacticalActionEvent) {
  let rift_count = movement.gravity_rift_transits(from, to, anomalies)
  case rift_count > 0 {
    False -> []
    True -> {
      let dice_count = self_propelled_count(units) * rift_count
      [
        events.GravityRiftEncountered(
          game_id,
          player_id,
          from,
          to,
          rift_count,
          dice_count,
        ),
      ]
    }
  }
}

pub fn apply(
  state: TacticalActionState,
  event: TacticalActionEvent,
) -> TacticalActionState {
  case event {
    SystemActivated(_, player_id, hex) ->
      TacticalActionState(..state, activation_history: [
        #(hex, player_id),
        ..state.activation_history
      ])

    TacticTokenSpent(_, _) -> state

    UnitsMoved(_, _, _, _, _) -> state

    CombatInitiated(_, _, _, _) -> state

    GravityRiftEncountered(_, _, from, to, _, _) ->
      TacticalActionState(..state, pending_rift_encounters: [
        #(from, to),
        ..state.pending_rift_encounters
      ])

    GravityRiftResolved(_, _, from, to, _) ->
      TacticalActionState(
        ..state,
        pending_rift_encounters: drop_first(state.pending_rift_encounters, #(
          from,
          to,
        )),
      )
  }
}

fn drop_first(lst: List(#(Hex, Hex)), target: #(Hex, Hex)) -> List(#(Hex, Hex)) {
  case lst {
    [] -> []
    [head, ..tail] if head == target -> tail
    [head, ..tail] -> [head, ..drop_first(tail, target)]
  }
}

fn self_propelled_count(units: List(unit.Unit)) -> Int {
  list.count(units, fn(u) {
    case u {
      unit.ShipUnit(unit.Ship(kind: unit.Fighter(..), ..)) -> False
      unit.ShipUnit(_) -> True
      _ -> False
    }
  })
}
