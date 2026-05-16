import game/action_cards.{type ActionCardIdentifier}

pub type ActionCardsEvent {
  CardDrawn(game_id: String, player_id: String, card: ActionCardIdentifier)
  CardPlayed(game_id: String, player_id: String, card: ActionCardIdentifier)
  CardDiscarded(game_id: String, player_id: String, card: ActionCardIdentifier)
  PendingEffectsRegistered(
    game_id: String,
    player_id: String,
    card: ActionCardIdentifier,
    count: Int,
  )
  EffectAcknowledged(
    game_id: String,
    player_id: String,
    card: ActionCardIdentifier,
  )
  CardEffectsResolved(
    game_id: String,
    player_id: String,
    card: ActionCardIdentifier,
  )
  CardEffectFailed(
    game_id: String,
    player_id: String,
    card: ActionCardIdentifier,
    reason: String,
  )
}
