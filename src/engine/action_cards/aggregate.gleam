import core/models/state/action_cards.{
  type ActionCardsState, type PendingCardEffect, ActionCardsState,
  PendingCardEffect,
}
import core/value_objects/game
import core/value_objects/player
import engine/action_cards/commands.{
  type ActionCardsCommand, AcknowledgeEffect, DiscardCard, DrawCard,
  EffectFailed, PlayCard, RegisterPendingEffects,
}
import engine/action_cards/events.{
  type ActionCardsEvent, CardDiscarded, CardDrawn, CardPlayed,
}
import game/action_cards as cards
import gleam/dict
import gleam/list
import gleam/result

pub fn handle_draw(
  command: ActionCardsCommand,
) -> Result(List(ActionCardsEvent), String) {
  let assert DrawCard(game_id, player_id, card) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  Ok([events.CardDrawn(game_id, player_id, card)])
}

pub fn handle_play(
  state: ActionCardsState,
  command: ActionCardsCommand,
) -> Result(List(ActionCardsEvent), String) {
  let assert PlayCard(game_id, player_id, card) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  use _ <- result.try(player_holds(state, player_id, card))
  Ok([
    events.CardPlayed(game_id, player_id, card),
    events.CardDiscarded(game_id, player_id, card),
  ])
}

pub fn handle_discard(
  state: ActionCardsState,
  command: ActionCardsCommand,
) -> Result(List(ActionCardsEvent), String) {
  let assert DiscardCard(game_id, player_id, card) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  use _ <- result.try(player_holds(state, player_id, card))
  Ok([events.CardDiscarded(game_id, player_id, card)])
}

pub fn handle_register_effects(
  _state: ActionCardsState,
  command: ActionCardsCommand,
) -> Result(List(ActionCardsEvent), String) {
  let assert RegisterPendingEffects(game_id, player_id, card, count) = command
  case count > 0 {
    True ->
      Ok([events.PendingEffectsRegistered(game_id, player_id, card, count)])
    False -> Error("Effect count must be positive")
  }
}

pub fn handle_acknowledge(
  state: ActionCardsState,
  command: ActionCardsCommand,
) -> Result(List(ActionCardsEvent), String) {
  let assert AcknowledgeEffect(game_id, player_id, card) = command
  use pending <- result.try(find_pending(state, player_id, card))
  case pending.remaining - 1 {
    0 ->
      Ok([
        events.EffectAcknowledged(game_id, player_id, card),
        events.CardEffectsResolved(game_id, player_id, card),
      ])
    _ -> Ok([events.EffectAcknowledged(game_id, player_id, card)])
  }
}

pub fn handle_effect_failed(
  state: ActionCardsState,
  command: ActionCardsCommand,
) -> Result(List(ActionCardsEvent), String) {
  let assert EffectFailed(game_id, player_id, card, reason) = command
  use _ <- result.try(find_pending(state, player_id, card))
  Ok([events.CardEffectFailed(game_id, player_id, card, reason)])
}

fn find_pending(
  state: ActionCardsState,
  player_id: String,
  card: cards.ActionCardIdentifier,
) -> Result(PendingCardEffect, String) {
  state.pending_effects
  |> list.find(fn(p) { p.player_id == player_id && p.card == card })
  |> result.replace_error("No pending effect for this card")
}

fn player_holds(
  state: ActionCardsState,
  player_id: String,
  card: cards.ActionCardIdentifier,
) -> Result(Nil, String) {
  let hand = dict.get(state.hands, player_id) |> result.unwrap([])
  case list.contains(hand, card) {
    True -> Ok(Nil)
    False -> Error("Player does not hold that card")
  }
}

pub fn apply(
  state: ActionCardsState,
  event: ActionCardsEvent,
) -> ActionCardsState {
  case event {
    CardDrawn(_, player_id, card) -> {
      let current = dict.get(state.hands, player_id) |> result.unwrap([])
      ActionCardsState(
        ..state,
        hands: dict.insert(state.hands, player_id, [card, ..current]),
      )
    }

    CardPlayed(_, _, _) -> state

    CardDiscarded(_, player_id, card) -> {
      let current = dict.get(state.hands, player_id) |> result.unwrap([])
      ActionCardsState(
        ..state,
        hands: dict.insert(state.hands, player_id, remove_first(current, card)),
        discard: [card, ..state.discard],
      )
    }

    events.PendingEffectsRegistered(_, player_id, card, count) ->
      ActionCardsState(..state, pending_effects: [
        PendingCardEffect(player_id, card, count),
        ..state.pending_effects
      ])

    events.EffectAcknowledged(_, player_id, card) ->
      ActionCardsState(
        ..state,
        pending_effects: list.map(state.pending_effects, fn(p) {
          case p.player_id == player_id && p.card == card {
            True -> PendingCardEffect(..p, remaining: p.remaining - 1)
            False -> p
          }
        }),
      )

    events.CardEffectsResolved(_, player_id, card) ->
      ActionCardsState(
        ..state,
        pending_effects: list.filter(state.pending_effects, fn(p) {
          p.player_id != player_id || p.card != card
        }),
      )

    events.CardEffectFailed(_, player_id, card, _) ->
      ActionCardsState(
        ..state,
        pending_effects: list.filter(state.pending_effects, fn(p) {
          p.player_id != player_id || p.card != card
        }),
      )
  }
}

fn remove_first(
  xs: List(cards.ActionCardIdentifier),
  target: cards.ActionCardIdentifier,
) -> List(cards.ActionCardIdentifier) {
  case xs {
    [] -> []
    [x, ..rest] ->
      case x == target {
        True -> rest
        False -> [x, ..remove_first(rest, target)]
      }
  }
}
