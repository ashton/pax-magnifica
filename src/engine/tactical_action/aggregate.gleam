import core/models/hex/hex
import core/models/state/tactical_action.{type TacticalActionState}
import core/models/unit
import core/value_objects/game
import core/value_objects/player
import engine/tactical_action/commands.{
  type TacticalActionCommand, ActivateSystem, MoveShips,
}
import engine/tactical_action/events.{type TacticalActionEvent}
import gleam/list
import gleam/result

pub fn handle_activate(
  state: TacticalActionState,
  command: TacticalActionCommand,
) -> Result(List(TacticalActionEvent), String) {
  let assert ActivateSystem(game_id, player_id, hex) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  use _ <- result.try(case list.any(state.activation_history, fn(entry) { entry.0 == hex }) {
    True -> Error("Player has already activated this system")
    False -> Ok(Nil)
  })
  Ok([
    events.SystemActivated(game_id, player_id, hex),
    events.TacticTokenSpent(game_id, player_id),
  ])
}

pub fn handle_move_ships(
  state: TacticalActionState,
  command: TacticalActionCommand,
) -> Result(List(TacticalActionEvent), String) {
  let assert MoveShips(game_id, player_id, from, ships) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  use #(active_hex, _) <- result.try(
    list.first(state.activation_history)
    |> result.replace_error("No system has been activated yet"),
  )
  use _ <- result.try(case from == active_hex {
    True -> Error("Cannot move ships from the activated system itself")
    False -> Ok(Nil)
  })
  use _ <- result.try(case list.any(state.activation_history, fn(entry) { entry.0 == from }) {
    True -> Error("Cannot move ships from a system that has already been activated")
    False -> Ok(Nil)
  })
  use _ <- result.try(case ships {
    [] -> Error("Must move at least one ship")
    _ -> Ok(Nil)
  })
  use distance <- result.try(
    hex.distance(from, active_hex)
    |> result.replace_error("Could not calculate distance between systems"),
  )
  use _ <- result.try(case list.all(ships, fn(ship) { ship.movement >= distance }) {
    True -> Ok(Nil)
    False -> Error("Some ships do not have enough movement to reach the activated system")
  })
  Ok([events.ShipsMoved(game_id, player_id, from: from, to: active_hex, ships: ships)])
}
