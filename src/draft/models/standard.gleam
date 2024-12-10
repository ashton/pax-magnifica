import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game.{type Position}
import core/models/map.{type Tile}
import core/models/planetary_system.{type System}
import core/models/player.{type User}
import gleam/option.{type Option}

pub type SystemDraft {
  SystemDraft(user: User, system: System, col: Int, row: Int)
}

pub type StandardDraftPool {
  StandardDraftPool(
    available_factions: List(FactionIdentifier),
    available_systems: List(#(User, List(System))),
  )
}

pub type StandardDraftResult {
  StandardDraftResult(
    user: User,
    tiles: List(Tile),
    faction: Option(FactionIdentifier),
    position: Option(Position),
    color: Option(Color),
  )
}
