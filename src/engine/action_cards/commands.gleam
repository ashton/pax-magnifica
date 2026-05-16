import game/action_cards.{type ActionCardIdentifier}

pub type ActionCardsCommand {
  DrawCard(game_id: String, player_id: String, card: ActionCardIdentifier)
  PlayCard(game_id: String, player_id: String, card: ActionCardIdentifier)
  DiscardCard(game_id: String, player_id: String, card: ActionCardIdentifier)
  RegisterPendingEffects(
    game_id: String,
    player_id: String,
    card: ActionCardIdentifier,
    count: Int,
  )
  AcknowledgeEffect(
    game_id: String,
    player_id: String,
    card: ActionCardIdentifier,
  )
  EffectFailed(
    game_id: String,
    player_id: String,
    card: ActionCardIdentifier,
    reason: String,
  )
}

pub fn draw_card(
  game_id: String,
  player_id: String,
  card: ActionCardIdentifier,
) -> ActionCardsCommand {
  DrawCard(game_id, player_id, card)
}

pub fn play_card(
  game_id: String,
  player_id: String,
  card: ActionCardIdentifier,
) -> ActionCardsCommand {
  PlayCard(game_id, player_id, card)
}

pub fn discard_card(
  game_id: String,
  player_id: String,
  card: ActionCardIdentifier,
) -> ActionCardsCommand {
  DiscardCard(game_id, player_id, card)
}
