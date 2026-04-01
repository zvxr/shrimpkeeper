# CHANGELOG.md

## v2026.3

- Release `v2026.3`.
- Added a late-game pH shop that unlocks at `20+` shrimp or day `35+`.
- Added more tank life and interactions including algae, microorganisms, moss balls, improved snails, and held-object handling.
- Tightened placement and movement rules to reduce bad drops and shrimp/snail collision issues while keeping rapid algae handling.
- Rebalanced progression and economy across fancy shrimp, culling, stock limits, score weighting, and trait/mutation behavior.
- Bacter AE is now weaker per purchase and split between the Plant Shop and Glass Shop at `4` each.
- Glass Shop Bacter AE now costs `28`.
- Moss ball purchases are now capped at `20` total across the plant and discount shops.
- The day number in the HUD now changes color across the four in-day timing phases.
- Game over now pauses for about `1` second before allowing return to the title.
- Shops now play `sfx(7)` the first time they become available.
- Base breeding success is now `2/3` per eligible room.
- Snails eating algae now lower `TDS` by `3` and play `sfx(8)`.
- `kH+` no longer increases `gH`.
- Main Shop now sells `TDS+` for `8`; `Fancy` was removed from the main shop.
- Algae no longer block other algae, reducing soft-locks from dense algae clumps.
- Algae blooms no longer place algae in the top HUD rows.
- Discount Shop is now the Thrift Shop and also appears when any shrimp has purity `<0.5`.
- Fine Shop is now the Grow Shop and ages a held fry by `1`.
- Purchased creatures now place left or right based on the player's last horizontal input.
- Grow Shop age-up cost is now `5`.
- Shrimp Shop now sells any held adult shrimp instead of using a purity gate.
- `pH+` now starts at `15` and increases by `5` for each one already bought.
- Day `41` now shows `Last day` in red, and day `42` ends the game automatically.
- Game-over scoring and panel layout were reworked around days, adult count, max purity, and rank titles.
- Grow Shop now shows the target fry age in the prompt and does not offer growth for adults.
- Red warning days now play `sfx(5)` and tint the HUD/task bar instead of drawing `x` marks.
- Starting `kH` is now `0` instead of `4.0`.
- Fine Shop now appears when there is any adult shrimp.

## v2026.2

- Release `v2026.2`, currently using `6734` PICO-8 tokens.
- Added a full title/help flow, persistent high score, improved game-over screen, and timed day/event messaging on the HUD.
- Expanded tank simulation with old-tank effects, algae blooms, genetics upgrades, and richer breeding outcomes including special high-purity birth events.
- Added and refined multiple shops: main, plant, shrimp sell, discount, culling, and genetics.
- The former culling shop is now the Fine Shop, unlocked by `5.0` purity births and selling water plus fancy shrimp.
- Fine Shop Fancy now costs `40`.
- Plant shop visibility is now dynamic at `10+` total shrimp instead of a permanent adult-based unlock.
- Recorded rough-vs-actual token calibration notes for future Codex work.
