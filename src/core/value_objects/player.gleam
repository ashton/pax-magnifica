import core/models/strategy_card.{type StrategyCard}
import gleam/string

pub opaque type PlayerId {
  PlayerId(String)
}

pub opaque type PlayerOrder {
  PlayerOrder(List(String))
}

pub opaque type PlayerCards {
  PlayerCards(List(#(String, StrategyCard)))
}

pub fn new_id(id: String) -> Result(PlayerId, String) {
  case string.is_empty(id) {
    True -> Error("Player id cannot be empty")
    False -> Ok(PlayerId(id))
  }
}

pub fn id_value(id: PlayerId) -> String {
  let PlayerId(s) = id
  s
}

pub fn new_order(ids: List(String)) -> Result(PlayerOrder, String) {
  case ids {
    [] -> Error("Player order cannot be empty")
    _ -> Ok(PlayerOrder(ids))
  }
}

pub fn order_values(order: PlayerOrder) -> List(String) {
  let PlayerOrder(ids) = order
  ids
}

pub fn new_cards(
  cards: List(#(String, StrategyCard)),
) -> Result(PlayerCards, String) {
  case cards {
    [] -> Error("Player cards cannot be empty")
    _ -> Ok(PlayerCards(cards))
  }
}

pub fn cards_values(cards: PlayerCards) -> List(#(String, StrategyCard)) {
  let PlayerCards(c) = cards
  c
}
