import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import ids/uuid
import models/agenda.{type AgendaType}
import models/common.{type Color}
import models/map.{type Map}
import models/objective.{type Objective}
import models/player.{type Player}

pub type Score {
  Score(objective: Objective, color: Color)
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
  uuid.generate_v4()
  |> result.map(fn(id) {
    Game(
      id: id,
      players: dict.new(),
      map: map.default(),
      public_objectives: [],
      scored_public_objectives: [],
      scored_secret_objectives: [],
      elected_laws: [],
    )
  })
}

pub fn setup_game(
  players players: List(#(Color, Player)),
  map map: Map,
) -> Result(Game, String) {
  let players_by_color =
    list.fold(over: players, from: dict.new(), with: fn(acc, item) {
      let #(color, player) = item
      acc |> dict.insert(color, player)
    })

  uuid.generate_v4()
  |> result.map(fn(id) {
    Game(
      id: id,
      players: players_by_color,
      map: map,
      public_objectives: [],
      scored_public_objectives: [],
      scored_secret_objectives: [],
      elected_laws: [],
    )
  })
}
