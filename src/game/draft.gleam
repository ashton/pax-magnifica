import game/drafts/milty as milty_draft
import gleam/option.{None, Some}
import models/common.{type Color}
import models/draft.{
  type Draft, type DraftType, DraftCompleted, Milty, MiltyDraft, Standard,
  StandardDraft,
}
import models/faction.{type FactionIdentifier}
import models/game.{type Game, type Position}
import models/planetary_system.{type System}
import models/player.{type User}

pub fn setup(kind: DraftType, users: List(User)) {
  case kind {
    Milty -> milty_draft.setup(users |> Some, override_player_count: None)
    Standard -> todo
  }
}

pub fn set_faction(
  draft draft: Draft,
  user user: User,
  faction faction_identifier: FactionIdentifier,
) {
  case draft {
    MiltyDraft(result:, participants:, pool:, state:) -> {
      milty_draft.select_faction(
        draft: result,
        user:,
        faction: faction_identifier,
      )
      |> MiltyDraft(state:, pool:, participants:, result: _)
    }

    StandardDraft(..) -> todo
  }
}

pub fn set_position(
  draft draft: Draft,
  user user: User,
  position position: Position,
) {
  case draft {
    MiltyDraft(result:, participants:, pool:, state:) -> {
      milty_draft.select_position(draft: result, user:, position:)
      |> MiltyDraft(state:, pool:, participants:, result: _)
    }
    StandardDraft(..) -> todo
  }
}

pub fn set_color(draft draft: Draft, user user: User, color color: Color) {
  let result = case draft {
    MiltyDraft(result:, ..) ->
      milty_draft.select_color(draft: result, user:, color:)

    StandardDraft(..) -> todo
  }
  // MiltyDraft(..draft, result:)
  // |> complete_if_needed()
}

pub fn finished(draft: Draft) {
  case draft {
    MiltyDraft(result:, ..) -> milty_draft.finished(result)
    StandardDraft(..) -> todo
  }
}

pub fn complete(draft: Draft) {
  case draft {
    MiltyDraft(result:, pool:, participants:, ..) ->
      MiltyDraft(result:, pool:, participants:, state: DraftCompleted)
    StandardDraft(..) -> todo
  }
}

fn complete_if_needed(draft: Draft) {
  case draft |> finished() {
    True -> draft |> complete()
    False -> draft
  }
}

pub fn new_game(draft: Draft) -> Game {
  case draft {
    MiltyDraft(..) -> milty_draft.new_game(draft)
    StandardDraft(..) -> todo
  }
}
