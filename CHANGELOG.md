# CHANGELOG.md

## v2026.1

- Added initial project changelog and title-screen version display.
- Added title/help flow before world start.
- Added persistent high score with default value `100`.
- Added game over score display.
- Added timed day/event messages on the status bar.
- Added algae blooms and algae pickup/feed behavior.
- Added old tank effects and related day messaging.
- Added multiple shops including plant, discount, culling, shrimp sell, and extra fancy.
- Added premium shrimp store options including metallic and devil-eyes shrimp.
- Added held-creature and inventory display refinements.
- Held items now drop to the left or right based on the player's last horizontal input.
- Reduced shrimp hitboxes to help prevent them sticking together:
  - fry width `0.3 -> 0.25`
  - adult width `0.7 -> 0.5`
- Moss balls are now kept out of the top HUD rows.
- Moss balls can now be picked up and carried.
- Game-over score now weights days survived more heavily.
- Fancy shrimp purity now scales from `1.0` up to `0.2 + current max purity`.
