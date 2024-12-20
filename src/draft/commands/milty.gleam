import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game.{type Position}
import core/models/planetary_system.{type System}
import core/models/player.{type User}
import draft/events/milty.{
  type MiltyDraftEvent, ColorSelected, FactionSelected, PositionSelected,
  SliceSelected,
}

pub type MiltyDraftCommand {
  PickFaction(user: User, faction: FactionIdentifier)
  PickSlice(user: User, slice: List(System))
  PickPosition(user: User, position: Position)
  PickColor(user: User, color: Color)
}

pub fn pick_faction(user user: User, faction faction: FactionIdentifier) {
  PickFaction(user:, faction:)
}

pub fn pick_position(user user: User, position position: Position) {
  PickPosition(user:, position:)
}

pub fn pick_color(user user: User, color color: Color) {
  PickColor(user:, color:)
}

pub fn pick_slice(user user: User, slice slice: List(System)) {
  PickSlice(user:, slice:)
}

pub fn handle_milty_command(command: MiltyDraftCommand) -> MiltyDraftEvent {
  case command {
    PickFaction(user:, faction:) -> FactionSelected(user:, faction:)
    PickColor(user:, color:) -> ColorSelected(user:, color:)
    PickPosition(user:, position:) -> PositionSelected(user:, position:)
    PickSlice(user:, slice:) -> SliceSelected(user:, slice:)
  }
}
