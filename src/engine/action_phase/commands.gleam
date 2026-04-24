import core/models/action.{type PlayerAction}
import core/models/strategy
import core/models/strategy_card.{type StrategyCard}
import gleam/int
import gleam/list

pub type ActionPhaseCommand {
  StartActionPhase(
    game_id: String,
    initiative_order: List(#(String, StrategyCard)),
  )
  TakeAction(game_id: String, player_id: String, action: PlayerAction)
  Pass(game_id: String, player_id: String)
}

pub fn start_action_phase(
  game_id: String,
  initiative_order: List(#(String, StrategyCard)),
) -> ActionPhaseCommand {
  let sorted =
    list.sort(initiative_order, fn(a, b) {
      int.compare(strategy.initiative(a.1.card), strategy.initiative(b.1.card))
    })
  StartActionPhase(game_id, sorted)
}

pub fn take_action(
  game_id: String,
  player_id: String,
  action: PlayerAction,
) -> ActionPhaseCommand {
  TakeAction(game_id, player_id, action)
}

pub fn pass(game_id: String, player_id: String) -> ActionPhaseCommand {
  Pass(game_id, player_id)
}
