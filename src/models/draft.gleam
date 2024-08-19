import models/drafts/milty.{type MiltyDraftPool, type MiltyDraftResult}
import models/player.{type User}

pub type DraftType {
  Milty
}

pub type Draft {
  MiltyDraft(
    kind: DraftType,
    pool: MiltyDraftPool,
    result: List(MiltyDraftResult),
    participants: List(User),
  )
}
