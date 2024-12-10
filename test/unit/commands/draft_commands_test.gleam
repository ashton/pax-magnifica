import draft/commands/draft as commands
import draft/events/draft as events
import draft/models/draft.{Milty, Standard}
import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

pub fn handle_prepare_standard_draft_test() {
  commands.prepare_draft(Standard)
  |> commands.handle_draft_command()
  |> should.equal(events.DraftInitiated(kind: Standard))
}

pub fn handle_prepare_milty_draft_test() {
  commands.prepare_draft(Milty)
  |> commands.handle_draft_command()
  |> should.equal(events.DraftInitiated(kind: Milty))
}
