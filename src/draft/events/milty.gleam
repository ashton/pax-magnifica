import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game.{type Position}
import core/models/planetary_system.{type System}
import core/models/player.{type User}
import draft/engine/milty as milty_draft
import draft/models/draft.{type Draft, MiltyDraft} as _

pub type MiltyDraftEvent {
  FactionSelected(faction: FactionIdentifier, user: User)
  SliceSelected(slice: List(System), user: User)
  PositionSelected(position: Position, user: User)
  ColorSelected(color: Color, user: User)
}

pub fn event_handler(
  event: MiltyDraftEvent,
  draft: Result(Draft, String),
) -> Result(Draft, String) {
  let assert Ok(MiltyDraft(result:, pool:, participants:, state:)) = draft

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
