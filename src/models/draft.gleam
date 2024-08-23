import models/drafts/milty.{type MiltyDraftPool, type MiltyDraftResult}
import models/drafts/standard.{type StandardDraftPool, type StandardDraftResult}
import models/player.{type User}

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
