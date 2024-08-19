import models/drafts/milty.{type MiltyDraftPool, type MiltyDraftResult}
import models/player.{type User}

pub type DraftType {
  Milty
}

pub type DraftState {
  DraftRunning
  DraftCompleted
}

pub type Draft {
  MiltyDraft(
    state: DraftState,
    pool: MiltyDraftPool,
    result: List(MiltyDraftResult),
    participants: List(User),
  )
}
