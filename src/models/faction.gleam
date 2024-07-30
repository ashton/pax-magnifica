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
  Arborec(FactionData)
  Letnev(FactionData)
  Saar(FactionData)
  Muaat(FactionData)
  Hacan(FactionData)
  Sol(FactionData)
  Creuss(FactionData)
  Lizix(FactionData)
  Mentak(FactionData)
  Naalu(FactionData)
  Nekro(FactionData)
  Sardakk(FactionData)
  JolNar(FactionData)
  Winnu(FactionData)
  Xxcha(FactionData)
  Yin(FactionData)
  Yssaril(FactionData)
}
