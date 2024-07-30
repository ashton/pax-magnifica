pub type Stage {
  StageOne
  StageTwo
}

pub type Phase {
  Action
  Status
  Agenda
}

pub type Objective {
  Public(name: String, stage: Stage, points: Int)
  Secret(name: String, phase: Phase, points: Int)
}
