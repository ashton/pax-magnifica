import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game.{type Position}
import core/models/planetary_system.{type System}
import core/models/player.{type User}
import core/models/state.{
  type State, DraftPhase, EndGamePhase, Initial, LobbyPhase, PlayingPhase,
}
import draft/engine/standard as std_draft
import draft/models/draft.{type Draft, StandardDraft} as _
import draft/models/standard.{type SystemDraft}
import gleam/result

pub type StandardDraftEvent {
  FactionSelected(faction: FactionIdentifier, user: User)
  SystemPlaced(SystemDraft)
  SpeakerSelected(user: User)
  ColorSelected(color: Color, user: User)
}

pub fn event_handler(
  event: StandardDraftEvent,
  draft: Draft,
) -> Result(Draft, String) {
  let assert StandardDraft(result:, pool:, participants:, state:) = draft

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
