import engine/action_cards/commands as action_cards_commands
import engine/action_cards/events as action_cards_events
import engine/effects/action_cards/economic_initiative
import engine/effects/types.{type EffectResult, DispatchCommand, NoEffect}
import engine/game/commands.{type GameCommand, ActionCardsCommand}
import engine/game/entity.{type GameEntity}
import engine/game/events.{type GameEvent, ActionCardsEvent}
import eventsourcing
import game/action_cards.{type ActionCardIdentifier, EconomicInitiative}
import gleam/erlang/process
import gleam/list

pub fn make_query(
  es_name: process.Name(
    eventsourcing.AggregateMessage(GameEntity, GameCommand, GameEvent, String),
  ),
) {
  fn(
    aggregate_id: eventsourcing.AggregateId,
    events: List(eventsourcing.EventEnvelop(GameEvent)),
  ) {
    list.each(events, fn(envelope) {
      case envelope.payload {
        ActionCardsEvent(action_cards_events.CardPlayed(
          game_id,
          player_id,
          card,
        )) -> {
          let es = process.named_subject(es_name)
          let subject = eventsourcing.load_aggregate(es, aggregate_id)
          case process.receive(subject, 5000) {
            Ok(Ok(agg)) ->
              execute_effect(
                es,
                aggregate_id,
                agg.entity,
                envelope.payload,
                game_id,
                player_id,
                card,
              )
            _ -> Nil
          }
        }
        _ -> Nil
      }
    })
  }
}

fn execute_effect(
  es: process.Subject(
    eventsourcing.AggregateMessage(GameEntity, GameCommand, GameEvent, String),
  ),
  aggregate_id: eventsourcing.AggregateId,
  entity: GameEntity,
  event: GameEvent,
  game_id: String,
  player_id: String,
  card: ActionCardIdentifier,
) {
  case dispatch_effect(entity, event) {
    NoEffect -> Nil
    DispatchCommand(cmd) -> {
      let register_cmd =
        ActionCardsCommand(action_cards_commands.RegisterPendingEffects(
          game_id,
          player_id,
          card,
          1,
        ))
      let r =
        eventsourcing.execute_with_response(es, aggregate_id, register_cmd, [])
      case process.receive(r, 5000) {
        Ok(Ok(Nil)) -> {
          let effect_result =
            eventsourcing.execute_with_response(es, aggregate_id, cmd, [])
          case process.receive(effect_result, 5000) {
            Ok(Ok(Nil)) -> {
              let ack_cmd =
                ActionCardsCommand(action_cards_commands.AcknowledgeEffect(
                  game_id,
                  player_id,
                  card,
                ))
              eventsourcing.execute(es, aggregate_id, ack_cmd)
            }
            _ -> {
              let fail_cmd =
                ActionCardsCommand(action_cards_commands.EffectFailed(
                  game_id,
                  player_id,
                  card,
                  "Effect command failed",
                ))
              eventsourcing.execute(es, aggregate_id, fail_cmd)
            }
          }
        }
        _ -> Nil
      }
    }
  }
}

pub fn dispatch_effect(entity: GameEntity, event: GameEvent) -> EffectResult {
  case event {
    ActionCardsEvent(action_cards_events.CardPlayed(_, _, card)) ->
      dispatch_card_effect(entity, event, card)
    _ -> NoEffect
  }
}

fn dispatch_card_effect(
  entity: GameEntity,
  event: GameEvent,
  card: ActionCardIdentifier,
) -> EffectResult {
  case card {
    EconomicInitiative -> {
      let assert ActionCardsEvent(inner) = event
      economic_initiative.execute(entity, inner)
    }
    _ -> NoEffect
  }
}
