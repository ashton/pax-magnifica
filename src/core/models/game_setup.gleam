pub type GameSetupType {
  Standard
  Milty
}

pub type GameSetupPhase {
  Lobby
  BuildingGalaxy
  PreparingGame
  SetupComplete
}

pub type GameSetup {
  GameSetup(
    game_id: String,
    player_count: Int,
    players: List(String),
    initial_speaker: String,
    map: String,
    phase: GameSetupPhase,
  )
}
