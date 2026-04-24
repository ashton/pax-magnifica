import engine/scoring/commands.{type ScoringCommand, AwardVictoryPoints}
import engine/scoring/events.{type ScoringEvent}

pub fn process(command: ScoringCommand) -> List(ScoringEvent) {
  case command {
    AwardVictoryPoints(game_id, player_id, source, amount) -> [
      events.PlayerScoredVictoryPoints(game_id, player_id, source, amount),
    ]
  }
}
