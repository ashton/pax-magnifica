import game/drafts/milty as milty_draft
import models/common.{type Color}
import models/draft.{type Draft, MiltyDraft} as _
import models/faction.{type FactionIdentifier}
import models/game.{type Position}
import models/planetary_system.{type System}
import models/player.{type User}

pub type MiltyDraftEvent {
  FactionSelected(faction: FactionIdentifier, user: User)
  SliceSelected(slice: List(System), user: User)
  PositionSelected(position: Position, user: User)
  ColorSelected(color: Color, user: User)
}

pub fn event_handler(
  event: MiltyDraftEvent,
  draft: Draft,
) -> Result(Draft, String) {
  let assert MiltyDraft(result:, pool:, participants:, state:) = draft

  let result = case event {
    FactionSelected(faction, user) ->
      milty_draft.select_faction(draft: result, faction:, user:)
    SliceSelected(slice, user) ->
      milty_draft.select_slice(draft: result, user:, systems: slice)
    ColorSelected(user: user, color: color) ->
      milty_draft.select_color(draft: result, user:, color:)
    PositionSelected(position:, user:) ->
      milty_draft.select_position(draft: result, position:, user:)
  }

  MiltyDraft(pool:, participants:, state:, result: result) |> Ok
}
