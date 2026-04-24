---
name: ti4-rules
description: Reference for Twilight Imperium 4th Edition game rules. Use whenever implementing or validating game mechanics — setup, phases, units, combat, objectives, strategy cards, etc.
---

# Twilight Imperium 4th Edition Rules Reference

The full rules are in `/home/john/dev/ti4/ti4-basegame-rules-compresssed.txt` (4548 lines).

When you need to check a rule, use the `Read` tool with `offset` and `limit` to jump to the relevant section. The index below maps each topic to its starting line.

## How to use

1. Find the topic in the index below.
2. `Read` the file starting at that line (use `limit: 80` or more as needed).
3. Apply the rule to the implementation.

---

## Section Index (line numbers)

| Line | Topic |
|------|-------|
| 1    | Using This Reference |
| 14   | Advanced Concepts — Golden Rules |
| 34   | Timing (general) |
| 47   | **Complete Setup** (all 12 steps) |
| 260  | Abilities |
| 422  | Action Cards |
| 470  | Action Phase |
| 590  | Active System |
| 616  | Adjacency |
| 644  | Agenda Phase |
| 682  | Agenda Cards (laws & directives) |
| 830  | Anomalies |
| 868  | Anti-Fighter Barrage (unit ability) |
| 940  | Asteroid Field |
| 973  | Attach |
| 988  | Attacker / Defender |
| 1007 | Bombardment (unit ability) |
| 1034 | Capacity (attribute) |
| 1039 | Blockaded |
| 1093 | Combat (attribute) |
| 1111 | Command Sheet |
| 1193 | Command Tokens |
| 1196 | Commodities |
| 1377 | Component Action |
| 1380 | Construction (strategy card) |
| 1415 | Component Limitations |
| 1526 | Control |
| 1573 | Deals |
| 1589 | Cost (attribute) |
| 1645 | Defender |
| 1654 | Custodians Token |
| 1656 | Destroyed |
| 1700 | Diplomacy (strategy card) |
| 1703 | Exhausted |
| 1748 | Elimination |
| 1853 | Fleet Pool |
| 1877 | Game Board |
| 1898 | Game Round (4 phases) |
| 1943 | Ground Forces |
| 1955 | Gravity Rift |
| 1992 | Ground Combat |
| 2015 | Influence |
| 2099 | Initiative Order |
| 2142 | Leadership (strategy card) |
| 2260 | Mecatol Rex |
| 2272 | Modifiers |
| 2296 | Nebula |
| 2316 | Movement |
| 2360 | Objective Cards (stage I, stage II, secret) |
| 2553 | Opponent |
| 2560 | PDS |
| 2730 | Planetary Shield (unit ability) |
| 2756 | Politics (strategy card) |
| 2786 | Producing Units |
| 2880 | Promissory Notes |
| 2946 | Production (unit ability) |
| 3020 | Ships |
| 3040 | Reinforcements |
| 3078 | Space Cannon (unit ability) |
| 3120 | Resources |
| 3138 | Rerolls |
| 3238 | Space Combat |
| 3395 | Status Phase |
| 3434 | Speaker |
| 3610 | Strategy Phase |
| 3628 | Strategy Cards |
| 3679 | Technology |
| 3759 | Supernova |
| 3768 | Sustain Damage (unit ability) |
| 3877 | System Tiles |
| 3878 | Tactical Action |
| 4082 | Trade (strategy card) |
| 4098 | Trade Goods |
| 4248 | Transport |
| 4329 | Units (all types with stats) |
| 4433 | Warfare (strategy card) |
| 4465 | Victory Points (14-point variant) |
| 4504 | Victory Points |
| 4525 | Wormholes |

---

## Key Domain Facts (quick reference)

### Game lifecycle
Setup → Strategy Phase → Action Phase → Status Phase → Agenda Phase → (repeat)

### Setup steps (lines 47–250)
1. Determine speaker (random)
2. Choose factions
3. Gather faction components
4. Choose color & components
5. Distribute starting planet cards
6. Create game board (3 rings around Mecatol Rex)
7. Place custodians token on Mecatol Rex
8. Shuffle common decks
9. Create supply
10. Gather strategy cards
11. Gather starting components (units + technologies)
12. Prepare objectives (deal secret, reveal 2 stage I public)

### Player counts & board
- 3–6 players (base game)
- 3-player: 2-ring grid; 4–6 player: 3-ring grid
- Mecatol Rex always at center (hex 18)

### Victory points
- Default: 10 VP track; optional 14 VP variant
- First player to reach target wins immediately

### Strategy cards (initiative order)
1. Leadership  2. Diplomacy  3. Politics  4. Construction
5. Trade       6. Warfare    7. Technology  8. Imperial

### Units (with rough stats — see line 4329 for full table)
- Carrier, Cruiser, Destroyer, Dreadnought, Fighter, Flagship, Infantry, PDS, Space Dock, War Sun
