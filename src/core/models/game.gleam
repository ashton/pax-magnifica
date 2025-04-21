import core/models/agenda.{type AgendaType}
import core/models/common.{type Color}
import core/models/map.{type Map}
import core/models/objective.{type Objective}
import core/models/player.{type Player}
import gleam/dict.{type Dict}
import gleam/list
import ids/uuid

pub type Score {
  Score(objective: Objective, color: Color)
}

pub type Position {
  Speaker
  Second
  Third
  Fourth
  Fifth
  Sixth
  Seventh
  Eighth
}

pub type Game {
  Game(
    id: String,
    players: Dict(Color, Player),
    public_objectives: List(Objective),
    scored_secret_objectives: List(Score),
    scored_public_objectives: List(Score),
    elected_laws: List(AgendaType),
    map: Map,
  )
}

pub fn default() {
  let assert Ok(id) = uuid.generate_v4()
  Game(
    id: id,
    players: dict.new(),
    map: map.default(),
    public_objectives: [],
    scored_public_objectives: [],
    scored_secret_objectives: [],
    elected_laws: [],
  )
}

pub fn setup_game(players players: List(#(Color, Player)), map map: Map) -> Game {
  let assert Ok(id) = uuid.generate_v4()
  let players_by_color =
    list.fold(over: players, from: dict.new(), with: fn(acc, item) {
      let #(color, player) = item
      acc |> dict.insert(color, player)
    })

  Game(
    id: id,
    players: players_by_color,
    map: map,
    public_objectives: [],
    scored_public_objectives: [],
    scored_secret_objectives: [],
    elected_laws: [],
  )
}

pub fn map_game_map(game: Game, updater: fn(Map) -> Map) -> Game {
  Game(..game, map: updater(game.map))
}
