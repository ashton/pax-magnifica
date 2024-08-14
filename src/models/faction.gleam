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
  Arborec(data: FactionData)
  Letnev(data: FactionData)
  Saar(data: FactionData)
  Muaat(data: FactionData)
  Hacan(data: FactionData)
  Sol(data: FactionData)
  Creuss(data: FactionData)
  Lizix(data: FactionData)
  Mentak(data: FactionData)
  Naalu(data: FactionData)
  Nekro(data: FactionData)
  Sardakk(data: FactionData)
  JolNar(data: FactionData)
  Winnu(data: FactionData)
  Xxcha(data: FactionData)
  Yin(data: FactionData)
  Yssaril(data: FactionData)
}
