import core/models/common.{Red}
import core/models/faction
import core/models/game
import core/models/player
import draft/commands/milty as commands
import draft/events/milty as events
import game/systems
import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

pub fn handle_pick_faction_command_test() {
  let user = player.User(name: "test")
  let faction = faction.Yin

  commands.pick_faction(user:, faction:)
  |> commands.handle_milty_command()
  |> should.equal(events.FactionSelected(user:, faction:))
}

pub fn handle_pick_color_command_test() {
  let user = player.User(name: "test")

  commands.pick_color(user:, color: Red)
  |> commands.handle_milty_command()
  |> should.equal(events.ColorSelected(user:, color: Red))
}

pub fn handle_pick_position_command_test() {
  let user = player.User(name: "test")

  commands.pick_position(user:, position: game.Second)
  |> commands.handle_milty_command()
  |> should.equal(events.PositionSelected(user:, position: game.Second))
}

pub fn handle_pick_slice_command_test() {
  let user = player.User(name: "test")
  let slice = [systems.letnev_home_system]

  commands.pick_slice(user:, slice:)
  |> commands.handle_milty_command()
  |> should.equal(events.SliceSelected(user:, slice:))
}
