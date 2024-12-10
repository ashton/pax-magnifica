import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game.{type Position}
import core/models/planetary_system.{type System}
import core/models/player.{type User}
import gleam/option.{type Option}

pub type MiltySlice {
  MiltySlice(home: Option(System), neighbors: List(System))
}

pub type MiltySliceCoordinate {
  MiltySliceCoordinate(home: #(Int, Int), neighbors: List(#(Int, Int)))
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
