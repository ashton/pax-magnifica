import core/models/planetary_system.{Cultural}
import core/models/state/planets.{Exhausted}
import engine/action_cards/events.{type ActionCardsEvent, CardPlayed}
import engine/effects/types.{type EffectResult, DispatchCommand, NoEffect}
import engine/game/commands.{PlanetsCommand}
import engine/game/entity.{type GameEntity}
import engine/game/lenses
import engine/planets/commands as planets_commands
import gleam/dict
import gleam/list
import gleam/option.{Some}
import ocular

pub fn execute(entity: GameEntity, event: ActionCardsEvent) -> EffectResult {
  let assert CardPlayed(game_id, player_id, _) = event
  let planets_state = ocular.get(entity, lenses.planets())
  let exhausted_cultural =
    planets_state.planets
    |> dict.to_list()
    |> list.filter_map(fn(pair) {
      let #(name, planet) = pair
      case
        planet.owner == player_id
        && planet.status == Exhausted
        && planet.trait == Some(Cultural)
      {
        True -> Ok(name)
        False -> Error(Nil)
      }
    })
  case exhausted_cultural {
    [] -> NoEffect
    names ->
      DispatchCommand(
        PlanetsCommand(planets_commands.ReadyPlanets(game_id, player_id, names)),
      )
  }
}
