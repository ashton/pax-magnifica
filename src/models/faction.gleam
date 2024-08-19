import models/common.{type Color}
import models/planetary_system.{type Planet}
import models/technology.{type Technology}
import models/unit.{type GroundForce, type Ship, type Structure, type UnitAmount}

pub type FactionData {
  FactionData(
    name: String,
    commodities: Int,
    ships: List(Ship),
    ground_forces: List(GroundForce),
    structures: List(Structure),
    starting_technologies: List(Technology),
    starting_units: List(UnitAmount),
    starting_planets: List(Planet),
    faction_technologies: List(Technology),
    suggested_colors: List(Color),
  )
}

pub type Faction {
  ArborecFaction(data: FactionData)
  LetnevFaction(data: FactionData)
  SaarFaction(data: FactionData)
  MuaatFaction(data: FactionData)
  HacanFaction(data: FactionData)
  SolFaction(data: FactionData)
  CreussFaction(data: FactionData)
  LizixFaction(data: FactionData)
  MentakFaction(data: FactionData)
  NaaluFaction(data: FactionData)
  NekroFaction(data: FactionData)
  SardakkFaction(data: FactionData)
  JolNarFaction(data: FactionData)
  WinnuFaction(data: FactionData)
  XxchaFaction(data: FactionData)
  YinFaction(data: FactionData)
  YssarilFaction(data: FactionData)
}

pub type FactionIdentifier {
  Arborec
  Letnev
  Saar
  Muaat
  Hacan
  Sol
  Creuss
  Lizix
  Mentak
  Naalu
  Nekro
  Sardakk
  JolNar
  Winnu
  Xxcha
  Yin
  Yssaril
}
