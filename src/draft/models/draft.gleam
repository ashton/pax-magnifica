import core/models/player.{type User}
import draft/models/milty.{type MiltyDraftPool, type MiltyDraftResult}
import draft/models/standard.{type StandardDraftPool, type StandardDraftResult}

pub type DraftType {
  Standard
  Milty
}

pub type DraftState {
  DraftRunning
  DraftCompleted
}

pub type Draft {
  StandardDraft(
    state: DraftState,
    pool: StandardDraftPool,
    result: List(StandardDraftResult),
    participants: List(User),
  )

  MiltyDraft(
    state: DraftState,
    pool: MiltyDraftPool,
    result: List(MiltyDraftResult),
    participants: List(User),
  )
}
