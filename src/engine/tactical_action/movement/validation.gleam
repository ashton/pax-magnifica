import core/models/hex/hex.{type Hex}
import core/models/planetary_system.{
  type Anomaly, AsteroidField, GravityRift, Nebula, Supernova,
}
import core/models/technology.{type Technology}
import core/models/unit.{type Unit}
import game/technologies
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

// Returns the number of gravity rift hexes a fleet transits when moving from
// `from` to `to`: the source hex plus any intermediate hexes, but never the
// destination. Called by the aggregate with the actual destination (which may
// be a blocked_at hex, not the active system) to determine dice_count.
pub fn gravity_rift_transits(
  from: Hex,
  to: Hex,
  anomalies: List(#(Hex, Anomaly)),
) -> Int {
  let rift_hexes =
    list.filter_map(anomalies, fn(a) {
      case a {
        #(h, GravityRift) -> Ok(h)
        _ -> Error(Nil)
      }
    })
  let intermediates = hex.path(from, to) |> result.unwrap([])
  [from, ..intermediates]
  |> list.count(fn(h) { list.contains(rift_hexes, h) })
}

// Validates movement range and resolves where the fleet ends up.
//
// Nebula rules applied here:
//   - Ships starting from a nebula treat their move value as 1.
//   - Nebulae on intermediate hexes are hard-blocked (ships cannot transit
//     through them). If no path exists avoiding nebulae, the move is invalid.
//   - Moving into a nebula is allowed only when it is the activated system
//     (the destination `to`), which is naturally satisfied by excluding `to`
//     from the hard-blocked set.
//
// Gravity rift rules applied here:
//   - Each rift hex in [from] ∪ {intermediate hexes} (not `to`) adds +1 to
//     the ship's effective movement (stacking per transit, per rule 6).
//   - Multiple rift tokens in one system still count as one (rule 8), which is
//     automatically satisfied since each hex has at most one anomaly type.
//
// Asteroid field rules applied here:
//   - Ships cannot move through or into an asteroid field.
//   - Exception: Antimass Deflectors technology removes this restriction.
//
// Enemy fleets are soft-blocked: ships stop at the first enemy and combat
// begins, but only when at least one nebula-free path exists.
pub fn resolve_path(
  from: Hex,
  to: Hex,
  units: List(Unit),
  enemy_fleets: List(#(Hex, String)),
  anomalies: List(#(Hex, Anomaly)),
  player_technologies: List(Technology),
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
  // Rule 3: ships starting in a nebula treat their move value as 1.
  let from_in_nebula =
    list.any(anomalies, fn(a) {
      case a {
        #(h, Nebula) if h == from -> True
        _ -> False
      }
    })
  // Gravity rift bonus: +1 per rift hex in [from] ∪ {intermediates} (not to).
  let rift_bonus = gravity_rift_transits(from, to, anomalies)
  let effective_movement = fn(ship: unit.Ship) {
    case from_in_nebula {
      True -> 1
      False -> ship.movement
    }
    + rift_bonus
  }
  use _ <- result.try(case
    list.all(self_propelled, fn(ship) { effective_movement(ship) >= distance })
  {
    True -> Ok(Nil)
    False -> Error("Some ships do not have enough movement to reach the activated system")
  })
  let min_movement =
    self_propelled
    |> list.map(effective_movement)
    |> list.reduce(int.min)
    |> result.unwrap(distance)
  let has_antimass_deflectors =
    list.contains(player_technologies, technologies.antimass_deflectors)
  // Supernova: ships can never enter one, even as the destination.
  use _ <- result.try(case
    list.any(anomalies, fn(a) {
      case a {
        #(h, Supernova) if h == to -> True
        _ -> False
      }
    })
  {
    True -> Error("Cannot move into a supernova")
    False -> Ok(Nil)
  })
  // Asteroid field: ships cannot move through or into one without Antimass Deflectors.
  use _ <- result.try(case has_antimass_deflectors {
    True -> Ok(Nil)
    False ->
      case
        list.any(anomalies, fn(a) {
          case a {
            #(h, AsteroidField) if h == to -> True
            _ -> False
          }
        })
      {
        True -> Error("Cannot move into an asteroid field")
        False -> Ok(Nil)
      }
  })
  // Hard-blocked hexes: nebulae on intermediate hexes + supernovae + asteroid
  // fields (without Antimass Deflectors) on any hex, all excluding `from`.
  let asteroid_blocked = case has_antimass_deflectors {
    True -> []
    False ->
      list.filter_map(anomalies, fn(a) {
        case a {
          #(h, AsteroidField) if h != from -> Ok(h)
          _ -> Error(Nil)
        }
      })
  }
  let hard_blocked =
    list.append(
      list.filter_map(anomalies, fn(a) {
        case a {
          #(h, Nebula) if h != from && h != to -> Ok(h)
          #(h, Supernova) if h != from -> Ok(h)
          _ -> Error(Nil)
        }
      }),
      asteroid_blocked,
    )
  let enemy_hex_list = list.map(enemy_fleets, fn(f) { f.0 })
  // Hard check: if no path exists avoiding hard-blocked hexes, the move is invalid.
  use _ <- result.try(case
    hex.has_path_avoiding(from, to, min_movement, hard_blocked)
  {
    True -> Ok(Nil)
    False -> Error("Cannot reach the activated system: all paths are blocked by anomalies")
  })
  // Soft check: if a path exists avoiding both nebulae and enemies, ships reach destination.
  case
    hex.has_path_avoiding(
      from,
      to,
      min_movement,
      list.append(hard_blocked, enemy_hex_list),
    )
  {
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
