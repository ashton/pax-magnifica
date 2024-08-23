import gleam/option.{type Option}
import models/common.{type Color}
import models/faction.{type FactionIdentifier}
import models/game.{type Position}
import models/map.{type Tile}
import models/planetary_system.{type System}
import models/player.{type User}

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
