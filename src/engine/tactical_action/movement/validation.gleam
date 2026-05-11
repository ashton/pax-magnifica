import core/models/hex/hex.{type Hex}
import core/models/unit.{type Unit}
import gleam/int
import gleam/list
import gleam/result

pub type Outcome {
  ReachDestination(hex: Hex)
  BlockedAt(hex: Hex, enemy_player_id: String)
}

pub fn not_empty(units: List(Unit)) -> Result(Nil, String) {
  case units {
    [] -> Error("Must move at least one unit")
    _ -> Ok(Nil)
  }
}

pub fn no_structures(units: List(Unit)) -> Result(Nil, String) {
  case list.any(units, fn(u) {
    case u {
      unit.Structure(_) -> True
      _ -> False
    }
  }) {
    True -> Error("Cannot move structures")
    False -> Ok(Nil)
  }
}

pub fn capacity(units: List(Unit)) -> Result(Nil, String) {
  let total =
    list.fold(units, 0, fn(acc, u) {
      acc
      + case u {
        unit.ShipUnit(ship) ->
          case ship.kind {
            unit.FlagShip(capacity: c) -> c
            unit.WarSun(capacity: c) -> c
            unit.Dreadnought(capacity: c) -> c
            unit.Carrier(capacity: c) -> c
            unit.Destroyer(capacity: c) -> c
            unit.Cruiser(capacity: c) -> c
            unit.Fighter(capacity: c, ..) -> c
          }
        _ -> 0
      }
    })
  let needed =
    list.length(list.filter(units, fn(u) {
      case u {
        unit.ShipUnit(unit.Ship(kind: unit.Fighter(..), ..)) -> True
        unit.GroundForce(_) -> True
        _ -> False
      }
    }))
  case total >= needed {
    True -> Ok(Nil)
    False -> Error("Not enough capacity to carry all fighters and ground forces")
  }
}

// Validates movement range and resolves where the fleet ends up, accounting
// for enemy fleets blocking intermediate systems. Ships route around blocked
// systems when their movement allows it.
pub fn resolve_path(
  from: Hex,
  to: Hex,
  units: List(Unit),
  enemy_fleets: List(#(Hex, String)),
) -> Result(Outcome, String) {
  use distance <- result.try(
    hex.distance(from, to)
    |> result.replace_error("Could not calculate distance between systems"),
  )
  let self_propelled =
    list.filter_map(units, fn(u) {
      case u {
        unit.ShipUnit(ship) ->
          case ship.kind {
            unit.Fighter(_, _) -> Error(Nil)
            _ -> Ok(ship)
          }
        _ -> Error(Nil)
      }
    })
  use _ <- result.try(case list.all(self_propelled, fn(ship) { ship.movement >= distance }) {
    True -> Ok(Nil)
    False -> Error("Some ships do not have enough movement to reach the activated system")
  })
  let min_movement =
    self_propelled
    |> list.map(fn(s) { s.movement })
    |> list.reduce(int.min)
    |> result.unwrap(distance)
  let enemy_hex_list = list.map(enemy_fleets, fn(f) { f.0 })
  case hex.has_path_avoiding(from, to, min_movement, enemy_hex_list) {
    True -> Ok(ReachDestination(to))
    False -> {
      use intermediate_hexes <- result.try(
        hex.path(from, to)
        |> result.replace_error("Could not calculate path between systems"),
      )
      case
        list.find_map(intermediate_hexes, fn(h) {
          list.find(enemy_fleets, fn(fleet) { fleet.0 == h })
          |> result.map(fn(fleet) { #(h, fleet.1) })
        })
      {
        Ok(#(blocked_at, enemy_player_id)) -> Ok(BlockedAt(blocked_at, enemy_player_id))
        Error(_) -> Ok(ReachDestination(to))
      }
    }
  }
}
