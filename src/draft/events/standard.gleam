import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/player.{type User}
import draft/engine/standard as std_draft
import draft/models/draft.{type Draft, StandardDraft} as _
import draft/models/standard.{type SystemDraft}

pub type StandardDraftEvent {
  FactionSelected(faction: FactionIdentifier, user: User)
  SystemPlaced(SystemDraft)
  SpeakerSelected(user: User)
  ColorSelected(color: Color, user: User)
}

pub fn event_handler(
  event: StandardDraftEvent,
  draft: Result(Draft, String),
) -> Result(Draft, String) {
  let assert Ok(StandardDraft(result:, pool:, participants:, state:)) = draft

  let result = case event {
    FactionSelected(faction, user) ->
      std_draft.select_faction(result:, faction:, user:)
    SpeakerSelected(user:) -> std_draft.build_positions(result:, speaker: user)
    SystemPlaced(system_draft) ->
      system_draft |> std_draft.place_system(result:)
    ColorSelected(user: user, color: color) ->
      std_draft.select_color(result:, user:, color:)
  }

  StandardDraft(pool:, participants:, state:, result: result) |> Ok
}
