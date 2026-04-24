import core/models/strategy.{type Strategy}

pub type StrategicActionCommand {
  StartStrategicAction(
    game_id: String,
    player_id: String,
    strategy: Strategy,
    secondary_order: List(String),
  )
  ResolveSecondaryAbility(game_id: String, player_id: String)
  SkipSecondaryAbility(game_id: String, player_id: String)
}

pub fn start_strategic_action(
  game_id: String,
  player_id: String,
  strategy: Strategy,
  secondary_order: List(String),
) -> StrategicActionCommand {
  StartStrategicAction(game_id, player_id, strategy, secondary_order)
}

pub fn resolve_secondary(
  game_id: String,
  player_id: String,
) -> StrategicActionCommand {
  ResolveSecondaryAbility(game_id, player_id)
}

pub fn skip_secondary(
  game_id: String,
  player_id: String,
) -> StrategicActionCommand {
  SkipSecondaryAbility(game_id, player_id)
}
