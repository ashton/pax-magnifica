import game/factions
import gleam/list
import gleam/option.{type Option, Some}
import models/common.{type Color}
import models/faction.{type FactionIdentifier}
import models/game.{type Position}
import models/planetary_system.{type System}
import models/player.{type User}

pub type MiltySlice {
  MiltySlice(home: Option(System), neighbors: List(System))
}

pub type MiltyDraftPool {
  MiltyDraftPool(
    available_factions: List(FactionIdentifier),
    available_slices: List(List(System)),
    available_positions: List(Position),
  )
}

pub type MiltyDraftResult {
  MiltyDraftResult(
    user: User,
    slice: MiltySlice,
    faction: Option(FactionIdentifier),
    position: Option(Position),
    color: Option(Color),
  )
}

pub fn select_faction(
  draft draft: List(MiltyDraftResult),
  user user: User,
  faction faction: FactionIdentifier,
) -> List(MiltyDraftResult) {
  draft
  |> list.map(fn(result) {
    case result.user == user {
      True ->
        MiltyDraftResult(
          ..result,
          faction: faction |> Some,
          slice: MiltySlice(
            home: faction |> factions.home_system() |> Some,
            neighbors: [],
          ),
        )
      False -> result
    }
  })
}

fn build_slice(
  faction: Option(FactionIdentifier),
  slice: MiltySlice,
  new_system: System,
) -> MiltySlice {
  let home =
    faction
    |> option.map(factions.home_system)
    |> option.or(slice.home, _)

  let neighbors = [new_system, ..slice.neighbors]

  MiltySlice(home:, neighbors:)
}

pub fn select_system(
  draft draft: List(MiltyDraftResult),
  user user: User,
  system system: System,
) -> List(MiltyDraftResult) {
  draft
  |> list.map(fn(result) {
    case result.user == user {
      True ->
        MiltyDraftResult(
          ..result,
          slice: build_slice(result.faction, result.slice, system),
        )
      False -> result
    }
  })
}

pub fn select_position(
  draft draft: List(MiltyDraftResult),
  user user: User,
  position position: Position,
) -> List(MiltyDraftResult) {
  draft
  |> list.map(fn(result) {
    case result.user == user {
      True -> MiltyDraftResult(..result, position: position |> Some)
      False -> result
    }
  })
}

pub fn select_color(
  draft draft: List(MiltyDraftResult),
  user user: User,
  color color: Color,
) {
  draft
  |> list.map(fn(result) {
    case result.user == user {
      True -> MiltyDraftResult(..result, color: color |> Some)
      False -> result
    }
  })
}
