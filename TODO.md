# TODO

## Game Setup

- [ ] **Winnu starting technology**: Winnu choose 1 technology with no prerequisites during setup instead of having a fixed starting tech. Needs a dedicated command/flow to handle this choice.
- [ ] **Sardakk starting technology**: Sardakk start with no technologies. Verify this is intentional and not a data gap when the full game loop is implemented.

## Known gaps (from setup rules analysis)

- [ ] **`StartGame` command**: Currently has no fields — cannot produce a valid `GameStarted(game_id, players, game_board)` event. Needs redesign.
- [ ] **`GameSetup` state**: Missing `setup_type` and `victory_points` fields — data from `GameCreated` event is not persisted to state.
- [ ] **Objectives setup (step 12)**: `DealObjectives` and `RevealPublicObjectives` commands are missing. Stage I/II objective dealing has no representation.
- [ ] **`SetupInitialComponents` command**: `InitialComponentsSetup` trigger for command tokens (3 tactic + 3 fleet + 2 strategy) not yet modeled — currently only technologies and units are handled.
- [ ] **Custodians token (step 7)**: Not modeled. Relevant later as it gates Mecatol Rex invasion and the agenda phase.
- [ ] **Starting planet cards (step 5)**: Not modeled. Derivable from faction data but may need explicit representation for full event sourcing.
