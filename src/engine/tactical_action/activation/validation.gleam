import core/models/hex/hex.{type Hex}
import core/models/state/tactical_action.{type TacticalActionState}
import gleam/list
import gleam/result

pub fn active_system(state: TacticalActionState) -> Result(Hex, String) {
  list.first(state.activation_history)
  |> result.map(fn(entry) { entry.0 })
  |> result.replace_error("No system has been activated yet")
}

pub fn not_already_activated(
  state: TacticalActionState,
  hex: Hex,
) -> Result(Nil, String) {
  case list.any(state.activation_history, fn(entry) { entry.0 == hex }) {
    True -> Error("Player has already activated this system")
    False -> Ok(Nil)
  }
}

pub fn valid_movement_source(
  state: TacticalActionState,
  from: Hex,
  active_hex: Hex,
) -> Result(Nil, String) {
  use _ <- result.try(case from == active_hex {
    True -> Error("Cannot move units from the activated system itself")
    False -> Ok(Nil)
  })
  case list.any(state.activation_history, fn(entry) { entry.0 == from }) {
    True ->
      Error("Cannot move units from a system that has already been activated")
    False -> Ok(Nil)
  }
}
