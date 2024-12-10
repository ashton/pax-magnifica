import draft/commands/milty.{type MiltyDraftCommand, handle_milty_command}

import draft/commands/standard.{
  type StandardDraftCommand, handle_standard_command,
}

import draft/events/draft.{
  type DraftEvent, DraftInitiated, MiltyDraftEvent, StandardDraftEvent,
} as _

import core/models/player.{type User}
import draft/models/draft.{type DraftType}

pub opaque type DraftCommand {
  PrepareDraft(DraftType, List(User))
  MiltyDraftCommand(MiltyDraftCommand)
  StandardDraftCommand(StandardDraftCommand)
}

pub fn prepare_draft(kind: DraftType, users: List(User)) -> DraftCommand {
  PrepareDraft(kind, users)
}

pub fn handle_draft_command(command: DraftCommand) -> DraftEvent {
  case command {
    PrepareDraft(kind, users) -> DraftInitiated(kind:, users:)
    MiltyDraftCommand(milty_command) ->
      handle_milty_command(milty_command) |> MiltyDraftEvent
    StandardDraftCommand(standard_command) ->
      handle_standard_command(standard_command) |> StandardDraftEvent
  }
}
