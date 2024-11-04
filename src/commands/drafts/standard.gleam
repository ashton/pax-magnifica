import events/drafts/standard.{
  ColorSelected, FactionSelected, SpeakerSelected, SystemPlaced,
}
import gleam/pair
import models/common.{type Color}
import models/drafts/standard.{SystemDraft} as _
import models/faction.{type FactionIdentifier}
import models/planetary_system.{type System}
import models/player.{type User}

pub opaque type StandardDraftCommand {
  SetSpeaker(user: User)
  PickFaction(user: User, faction: FactionIdentifier)
  PickColor(user: User, color: Color)
  PlaceSystem(user: User, system: System, coords: #(Int, Int))
}

pub fn set_speaker(user user: User) {
  SetSpeaker(user:)
}

pub fn pick_faction(user user: User, faction faction: FactionIdentifier) {
  PickFaction(user:, faction:)
}

pub fn pick_color(user user: User, color color: Color) {
  PickColor(user:, color:)
}

pub fn place_system(
  user user: User,
  system system: System,
  coords coords: #(Int, Int),
) {
  PlaceSystem(user:, system:, coords:)
}

pub fn handle_standard_command(command: StandardDraftCommand) {
  case command {
    SetSpeaker(user:) -> SpeakerSelected(user:)
    PickFaction(user:, faction:) -> FactionSelected(user:, faction:)
    PickColor(user:, color:) -> ColorSelected(user:, color:)
    PlaceSystem(user:, system:, coords:) ->
      SystemDraft(
        user:,
        system:,
        col: coords |> pair.first(),
        row: coords |> pair.second(),
      )
      |> SystemPlaced()
  }
}
