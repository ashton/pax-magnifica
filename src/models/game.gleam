import gleam/dict.{type Dict}
import models/agenda.{type AgendaType}
import models/common.{type Color}
import models/faction.{type Faction}
import models/map.{type Map}
import models/objective.{type Objective}
import models/player.{type Player}

pub type Participant {
  Participant(player: Player, faction: Faction)
}

pub type Score {
  Score(objective: Objective, color: Color)
}

pub type Game {
  Game(
    id: String,
    participants: Dict(Color, Participant),
    public_objectives: List(Objective),
    scored_secret_objectives: List(Score),
    scored_public_objectives: List(Score),
    elected_laws: List(AgendaType),
    map: Map,
  )
}
