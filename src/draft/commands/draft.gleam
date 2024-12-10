import draft/commands/milty.{type MiltyDraftCommand, handle_milty_command}

import draft/commands/standard.{
  type StandardDraftCommand, handle_standard_command,
}

import draft/events/draft.{
  type DraftEvent, DraftInitiated, MiltyDraftEvent, StandardDraftEvent,
} as _

import draft/models/draft.{type DraftType}

pub opaque type DraftCommand {
  PrepareDraft(DraftType)
  MiltyDraftCommand(MiltyDraftCommand)
  StandardDraftCommand(StandardDraftCommand)
}

pub fn prepare_draft(kind: DraftType) -> DraftCommand {
  PrepareDraft(kind)
}

pub fn handle_draft_command(command: DraftCommand) -> DraftEvent {
  case command {
    PrepareDraft(kind) -> DraftInitiated(kind:)
    MiltyDraftCommand(milty_command) ->
      handle_milty_command(milty_command) |> MiltyDraftEvent
    StandardDraftCommand(standard_command) ->
      handle_standard_command(standard_command) |> StandardDraftEvent
  }
}
