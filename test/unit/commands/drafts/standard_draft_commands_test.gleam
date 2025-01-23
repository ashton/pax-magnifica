import core/models/common.{Red}
import core/models/faction
import core/models/player
import draft/commands/standard as commands
import draft/events/standard as events
import draft/models/standard.{SystemDraft}
import game/systems
import glacier/should

pub fn handle_pick_faction_command_test() {
  let user = player.User(name: "test")
  let faction = faction.Yin

  commands.pick_faction(user:, faction:)
  |> commands.handle_standard_command()
  |> should.equal(events.FactionSelected(user:, faction:))
}

pub fn handle_pick_color_command_test() {
  let user = player.User(name: "test")

  commands.pick_color(user:, color: Red)
  |> commands.handle_standard_command()
  |> should.equal(events.ColorSelected(user:, color: Red))
}

pub fn handle_set_speaker_command_test() {
  let user = player.User(name: "test")

  commands.set_speaker(user:)
  |> commands.handle_standard_command()
  |> should.equal(events.SpeakerSelected(user:))
}

pub fn handle_place_system_command_test() {
  let user = player.User(name: "test")
  let system = systems.letnev_home_system
  let coords = #(-2, 3)

  commands.place_system(user:, system:, coords:)
  |> commands.handle_standard_command()
  |> should.equal(
    events.SystemPlaced(SystemDraft(user:, system:, col: -2, row: 3)),
  )
}
