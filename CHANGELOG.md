# CHANGELOG.md

## v2026.2

- Release `v2026.2`, currently using `6734` PICO-8 tokens.
- Added a full title/help flow, persistent high score, improved game-over screen, and timed day/event messaging on the HUD.
- Expanded tank simulation with old-tank effects, algae blooms, genetics upgrades, and richer breeding outcomes including special high-purity birth events.
- Added and refined multiple shops: main, plant, shrimp sell, discount, culling, and genetics.
- The former culling shop is now the Fine Shop, unlocked by `5.0` purity births and selling water plus fancy shrimp.
- Fine Shop Fancy now costs `40`.
- Plant shop visibility is now dynamic at `10+` total shrimp instead of a permanent adult-based unlock.
- Added a late-game pH shop that unlocks at `20+` shrimp or day `35+`.
- Added more tank life and interactions including algae, microorganisms, moss balls, improved snails, and held-object handling.
- Tightened placement and movement rules to reduce bad drops and shrimp/snail collision issues while keeping rapid algae handling.
- Rebalanced progression and economy across fancy shrimp, culling, stock limits, score weighting, and trait/mutation behavior.
- Bacter AE is now weaker per purchase and split between the Plant Shop and Glass Shop at `4` each.
- Glass Shop Bacter AE now costs `28`.
- Moss ball purchases are now capped at `20` total across the plant and discount shops.
- The day number in the HUD now changes color across the four in-day timing phases.
- Game over now pauses for about `1` second before allowing return to the title.
- Shops now play `sfx(8)` the first time they become available.
- Base breeding success is now `2/3` per eligible room.
- Snails eating algae now lower `TDS` by `3` and play `sfx(8)`.
- Recorded rough-vs-actual token calibration notes for future Codex work.
