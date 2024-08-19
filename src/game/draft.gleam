import game/drafts/milty as milty_draft
import gleam/option.{None, Some}
import models/draft.{type Draft, type DraftType, Milty, MiltyDraft}
import models/drafts/milty
import models/faction.{type FactionIdentifier}
import models/game.{type Position}
import models/planetary_system.{type System}
import models/player.{type User}

pub fn setup(kind: DraftType, users: List(User)) {
  case kind {
    Milty -> milty_draft.setup(users |> Some, override_player_count: None)
  }
}

pub fn set_faction(
  draft draft: Draft,
  user user: User,
  faction faction_identifier: FactionIdentifier,
) {
  case draft.kind {
    Milty -> {
      let result =
        milty.select_faction(
          draft: draft.result,
          user:,
          faction: faction_identifier,
        )

      MiltyDraft(..draft, result:)
    }
  }
}

pub fn set_system(draft draft: Draft, user user: User, system system: System) {
  case draft.kind {
    Milty -> {
      let result = milty.select_system(draft: draft.result, user:, system:)

      MiltyDraft(..draft, result:)
    }
  }
}

pub fn set_position(
  draft draft: Draft,
  user user: User,
  position position: Position,
) {
  case draft.kind {
    Milty -> {
      let result = milty.select_position(draft: draft.result, user:, position:)

      MiltyDraft(..draft, result:)
    }
  }
}
