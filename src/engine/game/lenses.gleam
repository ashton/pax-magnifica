import engine/game/entity.{type GameEntity, GameEntity}
import ocular

pub fn state() {
  ocular.lens(get: fn(e: GameEntity) { e.state }, set: fn(v, e: GameEntity) {
    GameEntity(..e, state: v)
  })
}

pub fn setup() {
  ocular.lens(get: fn(e: GameEntity) { e.setup }, set: fn(v, e: GameEntity) {
    GameEntity(..e, setup: v)
  })
}

pub fn strategy_phase() {
  ocular.lens(
    get: fn(e: GameEntity) { e.strategy_phase },
    set: fn(v, e: GameEntity) { GameEntity(..e, strategy_phase: v) },
  )
}

pub fn action_phase() {
  ocular.lens(
    get: fn(e: GameEntity) { e.action_phase },
    set: fn(v, e: GameEntity) { GameEntity(..e, action_phase: v) },
  )
}

pub fn strategic_action() {
  ocular.lens(
    get: fn(e: GameEntity) { e.strategic_action },
    set: fn(v, e: GameEntity) { GameEntity(..e, strategic_action: v) },
  )
}

pub fn tactical_action() {
  ocular.lens(
    get: fn(e: GameEntity) { e.tactical_action },
    set: fn(v, e: GameEntity) { GameEntity(..e, tactical_action: v) },
  )
}

pub fn action_cards() {
  ocular.lens(
    get: fn(e: GameEntity) { e.action_cards },
    set: fn(v, e: GameEntity) { GameEntity(..e, action_cards: v) },
  )
}

pub fn scoring() {
  ocular.lens(get: fn(e: GameEntity) { e.scoring }, set: fn(v, e: GameEntity) {
    GameEntity(..e, scoring: v)
  })
}
