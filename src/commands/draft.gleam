import commands/drafts/milty.{type MiltyDraftCommand, handle_milty_command}
import commands/drafts/standard.{
  type StandardDraftCommand, handle_standard_command,
}
import events/draft.{DraftInitiated, MiltyDraftEvent, StandardDraftEvent} as _
import models/draft.{type DraftType}
import models/event.{draft_event}

pub opaque type DraftCommand {
  PrepareDraft(DraftType)
  MiltyDraftCommand(MiltyDraftCommand)
  StandardDraftCommand(StandardDraftCommand)
}

pub fn prepare_draft(kind: DraftType) {
  PrepareDraft(kind)
}

pub fn handle_draft_command(command: DraftCommand) {
  case command {
    PrepareDraft(kind) -> DraftInitiated(kind:)
    MiltyDraftCommand(milty_command) ->
      handle_milty_command(milty_command) |> MiltyDraftEvent
    StandardDraftCommand(standard_command) ->
      handle_standard_command(standard_command) |> StandardDraftEvent
  }
  |> draft_event()
}
