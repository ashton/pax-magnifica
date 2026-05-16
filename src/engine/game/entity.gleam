import core/models/game_setup.{type GameSetup}
import core/models/state.{type State, Initial}
import core/models/state/action_cards.{type ActionCardsState, ActionCardsState}
import core/models/state/action_phase.{type ActionPhaseState}
import core/models/state/planets.{type PlanetsState}
import core/models/state/strategic_action.{type StrategicActionState}
import core/models/state/strategy_phase.{type StrategyPhaseState}
import core/models/state/tactical_action.{
  type TacticalActionState, TacticalActionState,
}
import engine/scoring/aggregate.{type ScoreState}
import gleam/dict
import gleam/option.{type Option, None}

pub type GameEntity {
  GameEntity(
    state: State,
    setup: Option(GameSetup),
    strategy_phase: Option(StrategyPhaseState),
    action_phase: Option(ActionPhaseState),
    strategic_action: Option(StrategicActionState),
    tactical_action: TacticalActionState,
    action_cards: ActionCardsState,
    planets: PlanetsState,
    scoring: Option(ScoreState),
  )
}

pub fn initial() -> GameEntity {
  GameEntity(
    state: Initial,
    setup: None,
    strategy_phase: None,
    action_phase: None,
    strategic_action: None,
    tactical_action: TacticalActionState(
      activation_history: [],
      pending_rift_encounters: [],
    ),
    action_cards: ActionCardsState(
      hands: dict.new(),
      discard: [],
      pending_effects: [],
    ),
    planets: planets.initial(),
    scoring: None,
  )
}
