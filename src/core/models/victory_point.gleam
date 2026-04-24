import core/models/objective.{type SecretObjective}

pub type VictoryPointSource {
  PublicObjectiveScored(objective_id: String)
  SecretObjectiveScored(objective: SecretObjective)
  Imperial
  Custodians
  Other(reason: String)
}
