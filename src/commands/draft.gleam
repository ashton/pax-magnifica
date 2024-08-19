import events/draft.{
  ColorSelected, DraftInitiated, FactionSelected, PositionSelected,
  SystemSelected,
} as _
import models/common.{type Color}
import models/draft.{type DraftType}
import models/event.{draft_event}
import models/faction.{type FactionIdentifier}
import models/game.{type Position}
import models/planetary_system.{type System}
import models/player.{type User}

pub opaque type DraftCommand {
  PrepareDraft(DraftType)
  PickFaction(user: User, faction: FactionIdentifier)
  PickSystem(user: User, system: System)
  PickPosition(user: User, position: Position)
  PickColor(user: User, color: Color)
}

pub fn prepare_draft(kind: DraftType) {
  PrepareDraft(kind)
}

pub fn pick_faction(user user: User, faction faction: FactionIdentifier) {
  PickFaction(user:, faction:)
}

pub fn pick_system(user user: User, system system: System) {
  PickSystem(user:, system:)
}

pub fn pick_position(user user: User, position position: Position) {
  PickPosition(user:, position:)
}

pub fn pick_color(user user: User, color color: Color) {
  PickColor(user:, color:)
}

pub fn handle_draft_command(command: DraftCommand) {
  case command {
    PrepareDraft(kind) -> DraftInitiated(kind:)
    PickFaction(user, faction) -> FactionSelected(faction, user)
    PickSystem(user, system) -> SystemSelected(system:, user:)
    PickPosition(user, position) -> PositionSelected(user:, position:)
    PickColor(user, color) -> ColorSelected(user:, color:)
  }
  |> draft_event()
}
