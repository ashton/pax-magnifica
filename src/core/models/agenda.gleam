pub type ElectionTarget {
  ScoredSecretObjective
  Player
  Planet
  ElectedLaw
}

pub type AgendaType {
  Election(name: String, text: String)
  ForAgainst(name: String, for_text: String, against_text: String)
}

pub type Agenda {
  Law(AgendaType)
  Directive(AgendaType)
}
