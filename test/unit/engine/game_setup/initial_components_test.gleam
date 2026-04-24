import core/models/faction.{
  Arborec, Creuss, Hacan, JolNar, Letnev, Lizix, Mentak, Muaat, Naalu, Nekro,
  Saar, Sardakk, Sol, Winnu, Xxcha, Yin, Yssaril,
}
import core/models/unit.{
  CarrierAmount, CruiserAmount, DestroyerAmount, DreadnoughtAmount,
  FighterAmount, InfantryAmount, PDSAmount, SpaceDockAmount, WarSunAmount,
}
import engine/game_setup/aggregate
import engine/game_setup/commands.{SetPlayerInitialComponents}
import game/planets
import game/technologies
import gleam/list

fn components_for(faction) {
  let assert SetPlayerInitialComponents(_, _, techs, units, starting_planets, _) =
    aggregate.setup_player_initial_components("game_1", "p1", faction)
  #(techs, units, starting_planets)
}

// ── Arborec ──────────────────────────────────────────────────────────────────

pub fn arborec_starting_technologies_test() {
  let #(techs, _, _) = components_for(Arborec)
  assert list.contains(techs, technologies.magen_defense_grid)
  assert list.length(techs) == 1
}

pub fn arborec_starting_units_test() {
  let #(_, units, _) = components_for(Arborec)
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, CruiserAmount(1))
  assert list.contains(units, FighterAmount(2))
  assert list.contains(units, InfantryAmount(4))
  assert list.contains(units, SpaceDockAmount(1))
  assert list.contains(units, PDSAmount(1))
}

// ── Letnev ───────────────────────────────────────────────────────────────────

pub fn letnev_starting_technologies_test() {
  let #(techs, _, _) = components_for(Letnev)
  assert list.contains(techs, technologies.antimass_deflectors)
  assert list.contains(techs, technologies.plasma_scoring)
  assert list.length(techs) == 2
}

pub fn letnev_starting_units_test() {
  let #(_, units, _) = components_for(Letnev)
  assert list.contains(units, DreadnoughtAmount(1))
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, DestroyerAmount(1))
  assert list.contains(units, FighterAmount(1))
  assert list.contains(units, InfantryAmount(3))
  assert list.contains(units, SpaceDockAmount(1))
}

// ── Saar ─────────────────────────────────────────────────────────────────────

pub fn saar_starting_technologies_test() {
  let #(techs, _, _) = components_for(Saar)
  assert list.contains(techs, technologies.antimass_deflectors)
  assert list.length(techs) == 1
}

pub fn saar_starting_units_test() {
  let #(_, units, _) = components_for(Saar)
  assert list.contains(units, DreadnoughtAmount(1))
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, DestroyerAmount(1))
  assert list.contains(units, FighterAmount(1))
  assert list.contains(units, InfantryAmount(3))
  assert list.contains(units, SpaceDockAmount(1))
}

// ── Muaat ────────────────────────────────────────────────────────────────────

pub fn muaat_starting_technologies_test() {
  let #(techs, _, _) = components_for(Muaat)
  assert list.contains(techs, technologies.plasma_scoring)
  assert list.length(techs) == 1
}

pub fn muaat_starting_units_test() {
  let #(_, units, _) = components_for(Muaat)
  assert list.contains(units, WarSunAmount(1))
  assert list.contains(units, FighterAmount(2))
  assert list.contains(units, InfantryAmount(4))
  assert list.contains(units, SpaceDockAmount(1))
}

// ── Hacan ────────────────────────────────────────────────────────────────────

pub fn hacan_starting_technologies_test() {
  let #(techs, _, _) = components_for(Hacan)
  assert list.contains(techs, technologies.antimass_deflectors)
  assert list.contains(techs, technologies.sarween_tools)
  assert list.length(techs) == 2
}

pub fn hacan_starting_units_test() {
  let #(_, units, _) = components_for(Hacan)
  assert list.contains(units, CarrierAmount(2))
  assert list.contains(units, CruiserAmount(1))
  assert list.contains(units, FighterAmount(2))
  assert list.contains(units, InfantryAmount(4))
  assert list.contains(units, SpaceDockAmount(1))
}

// ── Sol ──────────────────────────────────────────────────────────────────────

pub fn sol_starting_technologies_test() {
  let #(techs, _, _) = components_for(Sol)
  assert list.contains(techs, technologies.antimass_deflectors)
  assert list.contains(techs, technologies.neural_motivator)
  assert list.length(techs) == 2
}

pub fn sol_starting_units_test() {
  let #(_, units, _) = components_for(Sol)
  assert list.contains(units, CarrierAmount(2))
  assert list.contains(units, DestroyerAmount(1))
  assert list.contains(units, FighterAmount(3))
  assert list.contains(units, InfantryAmount(5))
  assert list.contains(units, SpaceDockAmount(1))
}

// ── Creuss ───────────────────────────────────────────────────────────────────

pub fn creuss_starting_technologies_test() {
  let #(techs, _, _) = components_for(Creuss)
  assert list.contains(techs, technologies.gravity_drive)
  assert list.length(techs) == 1
}

pub fn creuss_starting_units_test() {
  let #(_, units, _) = components_for(Creuss)
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, DestroyerAmount(2))
  assert list.contains(units, FighterAmount(2))
  assert list.contains(units, InfantryAmount(4))
  assert list.contains(units, SpaceDockAmount(1))
}

// ── L1Z1X ────────────────────────────────────────────────────────────────────

pub fn lizix_starting_technologies_test() {
  let #(techs, _, _) = components_for(Lizix)
  assert list.contains(techs, technologies.neural_motivator)
  assert list.contains(techs, technologies.plasma_scoring)
  assert list.length(techs) == 2
}

pub fn lizix_starting_units_test() {
  let #(_, units, _) = components_for(Lizix)
  assert list.contains(units, DreadnoughtAmount(1))
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, FighterAmount(3))
  assert list.contains(units, InfantryAmount(5))
  assert list.contains(units, SpaceDockAmount(1))
  assert list.contains(units, PDSAmount(1))
}

// ── Mentak ───────────────────────────────────────────────────────────────────

pub fn mentak_starting_technologies_test() {
  let #(techs, _, _) = components_for(Mentak)
  assert list.contains(techs, technologies.sarween_tools)
  assert list.contains(techs, technologies.plasma_scoring)
  assert list.length(techs) == 2
}

pub fn mentak_starting_units_test() {
  let #(_, units, _) = components_for(Mentak)
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, CruiserAmount(2))
  assert list.contains(units, FighterAmount(3))
  assert list.contains(units, InfantryAmount(4))
  assert list.contains(units, SpaceDockAmount(1))
  assert list.contains(units, PDSAmount(1))
}

// ── Naalu ────────────────────────────────────────────────────────────────────

pub fn naalu_starting_technologies_test() {
  let #(techs, _, _) = components_for(Naalu)
  assert list.contains(techs, technologies.sarween_tools)
  assert list.contains(techs, technologies.neural_motivator)
  assert list.length(techs) == 2
}

pub fn naalu_starting_units_test() {
  let #(_, units, _) = components_for(Naalu)
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, CruiserAmount(1))
  assert list.contains(units, DestroyerAmount(1))
  assert list.contains(units, FighterAmount(3))
  assert list.contains(units, InfantryAmount(4))
  assert list.contains(units, SpaceDockAmount(1))
  assert list.contains(units, PDSAmount(1))
}

// ── Nekro ────────────────────────────────────────────────────────────────────

pub fn nekro_starting_technologies_test() {
  let #(techs, _, _) = components_for(Nekro)
  assert list.contains(techs, technologies.dacxive_animators)
  assert list.length(techs) == 1
}

pub fn nekro_starting_units_test() {
  let #(_, units, _) = components_for(Nekro)
  assert list.contains(units, DreadnoughtAmount(1))
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, CruiserAmount(1))
  assert list.contains(units, FighterAmount(2))
  assert list.contains(units, InfantryAmount(2))
  assert list.contains(units, SpaceDockAmount(1))
}

// ── Sardakk N'orr ────────────────────────────────────────────────────────────

pub fn sardakk_starting_technologies_test() {
  let #(techs, _, _) = components_for(Sardakk)
  assert techs == []
}

pub fn sardakk_starting_units_test() {
  let #(_, units, _) = components_for(Sardakk)
  assert list.contains(units, CarrierAmount(2))
  assert list.contains(units, CruiserAmount(1))
  assert list.contains(units, InfantryAmount(5))
  assert list.contains(units, SpaceDockAmount(1))
  assert list.contains(units, PDSAmount(1))
}

// ── Jol-Nar ──────────────────────────────────────────────────────────────────

pub fn jol_nar_starting_technologies_test() {
  let #(techs, _, _) = components_for(JolNar)
  assert list.contains(techs, technologies.neural_motivator)
  assert list.contains(techs, technologies.antimass_deflectors)
  assert list.contains(techs, technologies.sarween_tools)
  assert list.contains(techs, technologies.plasma_scoring)
  assert list.length(techs) == 4
}

pub fn jol_nar_starting_units_test() {
  let #(_, units, _) = components_for(JolNar)
  assert list.contains(units, DreadnoughtAmount(1))
  assert list.contains(units, CarrierAmount(2))
  assert list.contains(units, FighterAmount(1))
  assert list.contains(units, InfantryAmount(2))
  assert list.contains(units, SpaceDockAmount(1))
  assert list.contains(units, PDSAmount(1))
}

// ── Winnu ────────────────────────────────────────────────────────────────────

pub fn winnu_starting_technologies_test() {
  // Winnu choose 1 tech with no prerequisites during setup — no fixed starting tech
  let #(techs, _, _) = components_for(Winnu)
  assert techs == []
}

pub fn winnu_starting_units_test() {
  let #(_, units, _) = components_for(Winnu)
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, CruiserAmount(1))
  assert list.contains(units, FighterAmount(2))
  assert list.contains(units, InfantryAmount(2))
  assert list.contains(units, SpaceDockAmount(1))
  assert list.contains(units, PDSAmount(1))
}

// ── Xxcha ────────────────────────────────────────────────────────────────────

pub fn xxcha_starting_technologies_test() {
  let #(techs, _, _) = components_for(Xxcha)
  assert list.contains(techs, technologies.graviton_laser_system)
  assert list.length(techs) == 1
}

pub fn xxcha_starting_units_test() {
  let #(_, units, _) = components_for(Xxcha)
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, CruiserAmount(2))
  assert list.contains(units, FighterAmount(3))
  assert list.contains(units, InfantryAmount(4))
  assert list.contains(units, SpaceDockAmount(1))
  assert list.contains(units, PDSAmount(1))
}

// ── Yin ──────────────────────────────────────────────────────────────────────

pub fn yin_starting_technologies_test() {
  let #(techs, _, _) = components_for(Yin)
  assert list.contains(techs, technologies.sarween_tools)
  assert list.length(techs) == 1
}

pub fn yin_starting_units_test() {
  let #(_, units, _) = components_for(Yin)
  assert list.contains(units, CarrierAmount(2))
  assert list.contains(units, DestroyerAmount(1))
  assert list.contains(units, FighterAmount(4))
  assert list.contains(units, InfantryAmount(4))
  assert list.contains(units, SpaceDockAmount(1))
}

// ── Yssaril ──────────────────────────────────────────────────────────────────

pub fn yssaril_starting_technologies_test() {
  let #(techs, _, _) = components_for(Yssaril)
  assert list.contains(techs, technologies.neural_motivator)
  assert list.length(techs) == 1
}

pub fn yssaril_starting_units_test() {
  let #(_, units, _) = components_for(Yssaril)
  assert list.contains(units, CarrierAmount(2))
  assert list.contains(units, DestroyerAmount(1))
  assert list.contains(units, FighterAmount(4))
  assert list.contains(units, InfantryAmount(4))
  assert list.contains(units, SpaceDockAmount(1))
}

// ── Starting planets ─────────────────────────────────────────────────────────

pub fn arborec_starting_planets_test() {
  let #(_, _, p) = components_for(Arborec)
  assert p == [planets.nestphar]
}

pub fn letnev_starting_planets_test() {
  let #(_, _, p) = components_for(Letnev)
  assert p == [planets.arc_prime, planets.wren_terra]
}

pub fn saar_starting_planets_test() {
  let #(_, _, p) = components_for(Saar)
  assert p == [planets.lisis_ii, planets.ragh]
}

pub fn muaat_starting_planets_test() {
  let #(_, _, p) = components_for(Muaat)
  assert p == [planets.muaat]
}

pub fn hacan_starting_planets_test() {
  let #(_, _, p) = components_for(Hacan)
  assert p == [planets.arretze, planets.hercant, planets.kamdorn]
}

pub fn sol_starting_planets_test() {
  let #(_, _, p) = components_for(Sol)
  assert p == [planets.jord]
}

pub fn creuss_starting_planets_test() {
  let #(_, _, p) = components_for(Creuss)
  assert p == [planets.creuss]
}

pub fn lizix_starting_planets_test() {
  let #(_, _, p) = components_for(Lizix)
  assert p == [planets.triplezero]
}

pub fn mentak_starting_planets_test() {
  let #(_, _, p) = components_for(Mentak)
  assert p == [planets.moll_primus]
}

pub fn naalu_starting_planets_test() {
  let #(_, _, p) = components_for(Naalu)
  assert p == [planets.maaluuk, planets.druaa]
}

pub fn nekro_starting_planets_test() {
  let #(_, _, p) = components_for(Nekro)
  assert p == [planets.mordai_ii]
}

pub fn sardakk_starting_planets_test() {
  let #(_, _, p) = components_for(Sardakk)
  assert p == [planets.trenlak, planets.quinarra]
}

pub fn jol_nar_starting_planets_test() {
  let #(_, _, p) = components_for(JolNar)
  assert p == [planets.jol, planets.nar]
}

pub fn winnu_starting_planets_test() {
  let #(_, _, p) = components_for(Winnu)
  assert p == [planets.winnu]
}

pub fn xxcha_starting_planets_test() {
  let #(_, _, p) = components_for(Xxcha)
  assert p == [planets.archon_ren, planets.archon_tau]
}

pub fn yin_starting_planets_test() {
  let #(_, _, p) = components_for(Yin)
  assert p == [planets.darien]
}

pub fn yssaril_starting_planets_test() {
  let #(_, _, p) = components_for(Yssaril)
  assert p == [planets.retillion, planets.shalloq]
}
