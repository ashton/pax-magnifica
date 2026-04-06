# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
gleam run                          # Run the project
gleam test                         # Run all tests
gleam format --check src test      # Check formatting
gleam format src test              # Auto-format code
gleam shell                        # Start Erlang REPL
gleam deps download                # Install dependencies
```

There is no single-test runner; all tests run together via `gleam test`.

## Architecture

This is a **Twilight Imperium 4th Edition** game engine written in **Gleam** (functional, statically typed, compiles to Erlang/OTP), using **DDD + CQRS + Event Sourcing** with the **Actor Model** (via `chip` and `gleam_otp`).

### Core Patterns

- **Commands** describe intent (write side). **Events** describe facts (immutable, logged). State is reconstructed by reducing events — never mutated directly.
- **Aggregates** validate commands and emit events. **Event handlers** fold events into state.
- Game lifecycle is a **state machine**: `Initial → Lobby → PlayerSetup → MapSetup → Active → Ended`.
- Each game runs as an isolated **OTP actor** managed by `SessionManager` (chip registry).

### Layer Structure

| Directory | Responsibility |
|---|---|
| `src/core/models/` | Pure domain types (Player, Game, Map, Hex, Factions, Units…) — no side effects |
| `src/engine/` | Command handlers, event handlers, aggregates per bounded context |
| `src/game/` | Static game data (all factions, planets, systems, technologies, units) |
| `src/actors/` | OTP infrastructure: `SessionManager` (registry) and `GameManager` (per-game actor) |
| `src/plugins/` | External adapters (e.g., Tabletop Simulator string parser) |
| `src/utils/` | UUID, Option, Result helpers |
| `test/unit/` | Unit tests mirroring `src/` structure |

### Bounded Contexts (inside `src/engine/`)

- **`lobby/`** — Player joining, seat assignment
- **`game_setup/`** — Aggregate for setup phase (standard vs. Milty Draft modes)
- **`map/`** — Hexagonal board construction and validation
- **`game/phases/lobby/`** — Orchestration of commands/events during the lobby phase

### Hexagonal Grid (`src/core/models/hex/`)

TI4 uses a hex map. The implementation uses **axial coordinates** (`hex.gleam`), with cube coordinate conversion (`vector.gleam`), ring operations (`ring.gleam`), and a grid container (`grid.gleam`).

### Adding a New Command/Event

1. Define the command type in the relevant `commands.gleam` inside the bounded context.
2. Define the event type in the matching `events.gleam`.
3. Implement the command handler (validates state → returns events).
4. Implement the event handler (folds event into state).
5. Wire into the top-level `engine/models/command.gleam` dispatcher.

### README

`README.md` contains the full DDD blueprint: Bounded Contexts, Ubiquitous Language glossary, and the complete Command/Event catalog. Read it for domain terminology and design intent before making significant domain changes.
