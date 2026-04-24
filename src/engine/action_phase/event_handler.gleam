import core/models/state/action_phase.{type ActionPhaseState, ActionPhaseState}
import core/models/strategy_card.{StrategyCard}
import engine/action_phase/events.{
  type ActionPhaseEvent, ActionPhaseEnded, ActionPhaseStarted, PlayerPassed,
  PlayerTookAction, StrategyCardExhausted,
}
import gleam/list
import gleam/option.{type Option, Some}

pub fn apply(
  state: Option(ActionPhaseState),
  event: ActionPhaseEvent,
) -> Option(ActionPhaseState) {
  case event {
    ActionPhaseStarted(_, player_cards) -> {
      let player_order = list.map(player_cards, fn(pc) { pc.0 })
      Some(ActionPhaseState(
        player_order: player_order,
        passed_players: [],
        last_player: option.None,
        player_cards: player_cards,
      ))
    }

    PlayerTookAction(_, player_id, _) ->
      option.map(state, fn(s) {
        ActionPhaseState(..s, last_player: Some(player_id))
      })

    StrategyCardExhausted(_, strat) ->
      option.map(state, fn(s) {
        let updated_cards =
          list.map(s.player_cards, fn(pc) {
            let #(pid, sc) = pc
            case sc.card == strat {
              True -> #(pid, StrategyCard(..sc, exhausted: True))
              False -> pc
            }
          })
        ActionPhaseState(..s, player_cards: updated_cards)
      })

    PlayerPassed(_, player_id) ->
      option.map(state, fn(s) {
        ActionPhaseState(
          ..s,
          passed_players: list.append(s.passed_players, [player_id]),
          last_player: Some(player_id),
        )
      })

    ActionPhaseEnded(_) -> state
  }
}
