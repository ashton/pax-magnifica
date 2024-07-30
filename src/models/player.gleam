import models/common.{type Strategy}
import models/faction.{type Faction}
import models/objective.{type Objective}
import models/planetary_system.{type Planet}
import models/promissory_notes.{type PromissoryNote}
import models/technology.{type Technology}

pub type Player {
  Player(
    name: String,
    faction: Faction,
    researched_technologies: List(Technology),
    tactical_actions: Int,
    strategical_actions: Int,
    fleet_size: Int,
    commodities: Int,
    trade_goods: Int,
    available_actions: List(String),
    available_secret_objectives: List(Objective),
    promissory_notes: List(PromissoryNote),
    current_strategy: Strategy,
    planets_under_control: List(Planet),
  )
}
