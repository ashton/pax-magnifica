import engine/action_cards/aggregate as action_cards_aggregate
import engine/action_cards/commands as action_cards_commands
import engine/action_phase/aggregate as action_phase_aggregate
import engine/action_phase/commands as action_phase_commands
import engine/game/commands.{
  type GameCommand, ActionCardsCommand, ActionPhaseCommand, LobbyCommand,
  MapCommand, ScoringCommand, SetupCommand, StrategicActionCommand,
  StrategyPhaseCommand, TacticalActionCommand,
}
import engine/game/entity.{type GameEntity}
import engine/game/events.{
  type GameEvent, ActionCardsEvent, ActionPhaseEvent, LobbyEvent, MapEvent,
  ScoringEvent, SetupEvent, StrategicActionEvent, StrategyPhaseEvent,
  TacticalActionEvent,
}
import engine/game/lenses
import engine/game_setup/aggregate as game_setup_aggregate
import engine/lobby/aggregate as lobby_aggregate
import engine/map/aggregate as map_aggregate
import engine/scoring/aggregate as scoring_aggregate
import engine/strategic_action/aggregate as strategic_action_aggregate
import engine/strategy_phase/aggregate as strategy_phase_aggregate
import engine/tactical_action/aggregate as tactical_action_aggregate
import engine/tactical_action/commands as tactical_action_commands
import engine/tactical_action/movement/context
import gleam/list
import gleam/option
import gleam/result
import ocular

pub fn handle(
  entity: GameEntity,
  command: GameCommand,
) -> Result(List(GameEvent), String) {
  case command {
    LobbyCommand(cmd) ->
      lobby_aggregate.handle(cmd)
      |> result.map(list.map(_, LobbyEvent))

    SetupCommand(cmd) ->
      game_setup_aggregate.handle(cmd)
      |> result.map(list.map(_, SetupEvent))

    MapCommand(cmd) ->
      map_aggregate.handle(cmd)
      |> result.map(list.map(_, MapEvent))

    StrategyPhaseCommand(cmd) ->
      strategy_phase_aggregate.handle(
        ocular.get(entity, lenses.strategy_phase()),
        cmd,
      )
      |> result.map(list.map(_, StrategyPhaseEvent))

    ActionPhaseCommand(cmd) ->
      handle_action_phase(entity, cmd)
      |> result.map(list.map(_, ActionPhaseEvent))

    StrategicActionCommand(cmd) ->
      strategic_action_aggregate.handle(
        ocular.get(entity, lenses.strategic_action()),
        cmd,
      )
      |> result.map(list.map(_, StrategicActionEvent))

    TacticalActionCommand(cmd) ->
      handle_tactical_action(entity, cmd)
      |> result.map(list.map(_, TacticalActionEvent))

    ActionCardsCommand(cmd) ->
      handle_action_cards(entity, cmd)
      |> result.map(list.map(_, ActionCardsEvent))

    ScoringCommand(cmd) ->
      scoring_aggregate.handle(cmd)
      |> result.map(list.map(_, ScoringEvent))
  }
}

fn handle_action_phase(entity: GameEntity, cmd) {
  case cmd {
    action_phase_commands.StartActionPhase(..) ->
      action_phase_aggregate.handle_start(cmd)
    action_phase_commands.TakeAction(..) -> {
      let assert option.Some(s) = ocular.get(entity, lenses.action_phase())
      action_phase_aggregate.handle_action(s, cmd)
    }
    action_phase_commands.Pass(..) -> {
      let assert option.Some(s) = ocular.get(entity, lenses.action_phase())
      action_phase_aggregate.handle_pass(s, cmd)
    }
  }
}

fn handle_tactical_action(entity: GameEntity, cmd) {
  let state = ocular.get(entity, lenses.tactical_action())
  case cmd {
    tactical_action_commands.ActivateSystem(..) ->
      tactical_action_aggregate.handle_activate(state, cmd)
    tactical_action_commands.MoveUnits(..) -> {
      let ctx =
        context.MovementContext(
          enemy_fleets: [],
          anomalies: [],
          player_technologies: [],
        )
      tactical_action_aggregate.handle_move_units(state, cmd, ctx)
    }
    tactical_action_commands.ResolveGravityRift(..) ->
      tactical_action_aggregate.handle_resolve_gravity_rift(state, cmd)
  }
}

fn handle_action_cards(entity: GameEntity, cmd) {
  let state = ocular.get(entity, lenses.action_cards())
  case cmd {
    action_cards_commands.DrawCard(..) ->
      action_cards_aggregate.handle_draw(cmd)
    action_cards_commands.PlayCard(..) ->
      action_cards_aggregate.handle_play(state, cmd)
    action_cards_commands.DiscardCard(..) ->
      action_cards_aggregate.handle_discard(state, cmd)
  }
}

pub fn apply(entity: GameEntity, event: GameEvent) -> GameEntity {
  case event {
    LobbyEvent(evt) ->
      ocular.modify(entity, lenses.state(), lobby_aggregate.apply(_, evt))

    SetupEvent(evt) ->
      ocular.modify(entity, lenses.setup(), game_setup_aggregate.apply(_, evt))

    MapEvent(evt) ->
      ocular.modify(entity, lenses.state(), map_aggregate.apply(_, evt))

    StrategyPhaseEvent(evt) ->
      ocular.modify(
        entity,
        lenses.strategy_phase(),
        strategy_phase_aggregate.apply(_, evt),
      )

    ActionPhaseEvent(evt) ->
      ocular.modify(entity, lenses.action_phase(), action_phase_aggregate.apply(
        _,
        evt,
      ))

    StrategicActionEvent(evt) ->
      ocular.modify(
        entity,
        lenses.strategic_action(),
        strategic_action_aggregate.apply(_, evt),
      )

    TacticalActionEvent(evt) ->
      ocular.modify(
        entity,
        lenses.tactical_action(),
        tactical_action_aggregate.apply(_, evt),
      )

    ActionCardsEvent(evt) ->
      ocular.modify(entity, lenses.action_cards(), action_cards_aggregate.apply(
        _,
        evt,
      ))

    ScoringEvent(evt) ->
      ocular.modify(entity, lenses.scoring(), scoring_aggregate.apply(_, evt))
  }
}
