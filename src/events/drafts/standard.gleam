import game/drafts/standard as std_draft
import gleam/result
import models/common.{type Color}
import models/draft.{type Draft, StandardDraft} as _
import models/drafts/standard.{type SystemDraft}
import models/faction.{type FactionIdentifier}
import models/game.{type Position}
import models/planetary_system.{type System}
import models/player.{type User}
import models/state.{
  type State, DraftPhase, EndGamePhase, Initial, LobbyPhase, PlayingPhase,
}

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
  let assert StandardDraft(result:, pool:, participants:, state:) =
    draft

  let result = case event {
    FactionSelected(faction, user) ->
      std_draft.select_faction(result:, faction:, user:)
    SpeakerSelected(user:) -> std_draft.build_positions(result:, speaker: user)
    SystemPlaced(system_draft) ->
      system_draft |> std_draft.place_system(result:)
    ColorSelected(user: user, color: color) ->
      std_draft.select_color(result:, user:, color:)
  }

  StandardDraft(pool:, participants:, state:, result: result,) |> Ok
}
