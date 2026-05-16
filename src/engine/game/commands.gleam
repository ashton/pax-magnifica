import engine/action_cards/commands as action_cards_commands
import engine/action_phase/commands as action_phase_commands
import engine/game_setup/commands as game_setup_commands
import engine/lobby/commands as lobby_commands
import engine/map/commands as map_commands
import engine/planets/commands as planets_commands
import engine/scoring/commands as scoring_commands
import engine/strategic_action/commands as strategic_action_commands
import engine/strategy_phase/commands as strategy_phase_commands
import engine/tactical_action/commands as tactical_action_commands

pub type GameCommand {
  LobbyCommand(lobby_commands.LobbyCommand)
  SetupCommand(game_setup_commands.GameSetupCommand)
  MapCommand(map_commands.MapCommand)
  StrategyPhaseCommand(strategy_phase_commands.StrategyPhaseCommand)
  ActionPhaseCommand(action_phase_commands.ActionPhaseCommand)
  StrategicActionCommand(strategic_action_commands.StrategicActionCommand)
  TacticalActionCommand(tactical_action_commands.TacticalActionCommand)
  ActionCardsCommand(action_cards_commands.ActionCardsCommand)
  PlanetsCommand(planets_commands.PlanetsCommand)
  ScoringCommand(scoring_commands.ScoringCommand)
}
