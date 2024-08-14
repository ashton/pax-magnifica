import gleam/option.{type Option, None}
import models/common.{type Strategy}
import models/faction.{type Faction}
import models/objective.{type Objective}
import models/planetary_system.{type Planet}
import models/promissory_notes.{type PromissoryNote}
import models/technology.{type Technology}

pub type User {
  User(name: String)
}

pub opaque type PlayerGameInfo {
  PlayerGameInfo(
    researched_technologies: List(Technology),
    tactical_actions: Int,
    strategical_actions: Int,
    fleet_size: Int,
    commodities: Int,
    trade_goods: Int,
    available_actions: List(String),
    available_secret_objectives: List(Objective),
    promissory_notes: List(PromissoryNote),
    current_strategy: Option(Strategy),
    planets_under_control: List(Planet),
  )
}

pub opaque type Player {
  Player(user: User, data: PlayerGameInfo, faction: Faction)
}

pub fn setup_player(user user: User, faction faction: Faction) {
  Player(
    user: user,
    faction: faction,
    data: PlayerGameInfo(
      researched_technologies: [],
      tactical_actions: 0,
      fleet_size: 0,
      strategical_actions: 0,
      commodities: faction.data.commodities,
      trade_goods: 0,
      available_actions: [],
      available_secret_objectives: [],
      promissory_notes: [],
      current_strategy: None,
      planets_under_control: [],
    ),
  )
}
