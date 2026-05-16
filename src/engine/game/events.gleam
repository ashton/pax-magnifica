import engine/action_cards/events as action_cards_events
import engine/action_phase/events as action_phase_events
import engine/game_setup/events as game_setup_events
import engine/lobby/events as lobby_events
import engine/map/events as map_events
import engine/planets/events as planets_events
import engine/scoring/events as scoring_events
import engine/strategic_action/events as strategic_action_events
import engine/strategy_phase/events as strategy_phase_events
import engine/tactical_action/events as tactical_action_events

pub type GameEvent {
  LobbyEvent(lobby_events.LobbyEvent)
  SetupEvent(game_setup_events.GameSetupEvent)
  MapEvent(map_events.MapEvent)
  StrategyPhaseEvent(strategy_phase_events.StrategyPhaseEvent)
  ActionPhaseEvent(action_phase_events.ActionPhaseEvent)
  StrategicActionEvent(strategic_action_events.StrategicActionEvent)
  TacticalActionEvent(tactical_action_events.TacticalActionEvent)
  ActionCardsEvent(action_cards_events.ActionCardsEvent)
  PlanetsEvent(planets_events.PlanetsEvent)
  ScoringEvent(scoring_events.ScoringEvent)
}
