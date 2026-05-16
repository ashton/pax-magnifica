import engine/game/commands.{type GameCommand}

pub type EffectResult {
  DispatchCommand(GameCommand)
  NoEffect
}
