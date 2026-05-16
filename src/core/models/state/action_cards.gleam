import game/action_cards.{type ActionCardIdentifier}
import gleam/dict.{type Dict}

pub type PendingCardEffect {
  PendingCardEffect(
    player_id: String,
    card: ActionCardIdentifier,
    remaining: Int,
  )
}

pub type ActionCardsState {
  ActionCardsState(
    hands: Dict(String, List(ActionCardIdentifier)),
    discard: List(ActionCardIdentifier),
    pending_effects: List(PendingCardEffect),
  )
}

pub fn initial() -> ActionCardsState {
  ActionCardsState(hands: dict.new(), discard: [], pending_effects: [])
}
