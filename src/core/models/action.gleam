import core/models/strategy.{type Strategy}

pub type PlayerAction {
  TacticalAction
  StrategicAction(strategy: Strategy)
  ComponentAction
}
