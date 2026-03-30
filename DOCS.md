# DOCS.md

## Coordinates

- high-level player-facing notes live in `INSTRUCTIONS.md`

- `x`, `y`: world position in map tiles
- screen size: `16x16` tiles
- used world span: `0,0` to `63,15`
- title/help screens use:
  - title: `(0,16)`
  - help 1: `(16,16)`
  - help 2: `(32,16)`

## Boot

- `_init()` now starts on the title flow, not the tank world
- title state fields:
  - `gs=0`: title/help mode
  - `gs=1`: normal game mode
  - `ts`: title selection (`1` start, `2` help)
  - `th`: title/help page (`0` title, `1` help 1, `2` help 2)
- `init_world()` is only called after selecting `start`
- while on title/help screens, `pl`, `tank`, and shrimp are not created yet
- high score is persisted with `cartdata`
- default high score is `100`

## Ent

Created by `make_ent(k,x,y)`.

- `k`: base sprite id
- `x`, `y`: world position
- `dx`, `dy`: velocity
- `frame`: current animation frame
- `t`: ticks alive
- `grav`: whether gravity applies
- `frames`: number of animation frames
- `fs`: sprite step between frames
- `sw`, `sh`: sprite width/height in sprite cells
- `w`, `h`: collision half-width/half-height in tiles

## Shrimp

- shrimp logic lives in `shrimp.lua`
- shrimp-only fields use `s*`
- `sa`: age in days
- `sp`: purity
- `sb`: base color line
  - `true`: red/orange line
  - `false`: yellow/green line
- `sr`: riley
- `sd`: devil eyes
- `st`: movement timer
- `sdx`: desired horizontal direction
- `so`: orientation (`0` left, `1` right)
- `sj`: remaining hop-chain jumps
- `ha`: currently held creature, or `nil`

### Age

- fry: `0..4`
- adult: `5+`
- on each new day, shrimp age by `1`
- fry use sprite strip `53..56` as `1x1`
- adults use sprite strip starting at `37` with `+2` frame steps as `2x1`
- fry hitbox is currently `w=0.2`, `h=0.25`
- adult hitbox is currently `w=0.42`, `h=0.25`

### Defaults

- `sa=8`
- `sp=0.5`
- `sb`: 50/50 random
- `sr`: 4/20 random
- `sd`: 1/20 random

### Initial Spawn

- initial world no longer places one fixed adult shrimp
- it now creates `4` fry shrimp
- initial fry colors are `2` red-line and `2` yellow-line
- initial fry age is randomized in `2..3`
- fry spawn in the coin box on horizontal screens `2` and `3`
- spawn band: `x=7..12 + 16*(1 or 2)`, `y=9..10`

### Movement

- shrimp use a small timer-driven wander loop
- they may idle, move left, move right, or hop
- they now idle a bit more often / longer
- a hop can start a short swim chain of `2..5` jumps total
- shrimp animation now follows `sdx` / hopping state, not collision rebound velocity
- age `0` fry are valid shrimp state and should still run shrimp logic
- adults currently use a slightly stronger move/hop impulse than fry
- overlapping shrimp apply a small separation push so they do not clump as easily
- a held shrimp is removed from `ent` until dropped again

### Breeding

- breeding is checked once on each new day
- requires:
  - two adult shrimp
  - same `sb`
  - same room
  - no tank parameter is dangerous/red
  - 2/3 success roll per room
- each of the `4` rooms is checked separately
- within an eligible room, a random same-line adult pair is used
- success creates one fry with `sa=1`
- successful breeding plays `sfx(4)`
- baby values:
  - `sp`: random from `(lowest-0.2)` to `(highest+0.2)`, then `+ tank.kh/4 + tank.gp*0.2`
  - `sb`: shared parent base color
  - `sr`: `TT -> T`, `TF -> 50% T`, `FF -> F`
  - `sd`: `TT -> T`, `TF -> 50% T`, `FF -> F`
- mutations:
  - `1/10`: `sp += 1`
  - `4/20 + gr/20`: `sr=true`
  - `1/20 + gd/20`: `sd=true`
  - fancy shrimp use doubled trait odds:
    - `8/20`: `sr=true`
    - `2/20`: `sd=true`
  - if a baby is born with `sp>=2`, the day message shows:
    - `BloodyMary!` for red-line shrimp
    - `GreenJade!` for yellow-line shrimp
  - if a baby is born with `sp>=5`, the day message shows:
    - `Calico!` for red-line shrimp
    - `Jelly!` for yellow-line shrimp
  - otherwise, if any mutation happens, the day message shows `Mutation!`

### Palette Mapping

- base sprite colors:
- legs `4`
- body `5`
- back `6`
- belly `7`
- eyes `14`

- `body`
  - `sp>=5`: `[15/12]`
  - `sp>=2`: `[2/3]`
  - `sp>=0.7`: `[8/11]`
  - `sp>=0.5`: `[9/10]`
  - else `[4/5]`

- `back`
  - `sp>=5`: `[15/12]`
  - `sp>=2`: `[2/3]`
  - `sp>=0.9`: `[8/11]`
  - `sp>=0.6`: `[9/10]`
  - else `[4/5]`

- `belly`
  - if `sr` and `sp>=5`: `[9/1]`
  - if `sr` and `sp>0.7`: `7`
  - else body color

- `eyes`
  - if `sd` and `sp>0.9`: `[10/9]`
  - else `14`

## Physics

- `gravity`: downward acceleration per update
- `fric`: shared velocity decay multiplier
- `bounce`: shared horizontal rebound amount on blocked movement
- player-to-ent horizontal collisions currently use a slightly stronger rebound to help herd shrimp
- if the player is moving upward into a shrimp, the shrimp gets a stronger upward and sideways push

## Snails

- snail logic lives in `snail.lua`
- `np`: purity
- `nb`: base color line
  - `true`: red/orange line
  - `false`: yellow/green line
- `nt`: movement timer
- `ndx`: desired horizontal direction
- `no`: orientation (`0` left, `1` right)
- snails use sprite strip `57..58`
- held snails use sprite `48`
- shell color uses:
  - `np>0.9`: `[2/3]`
  - `np>0.7`: `[8/11]`
  - `np>0.4`: `[9/10]`
  - else `5`
- snails do not age or breed
- snails are more active now, ignore entity collision, and avoid walking off ledges

## Algae

- algae logic lives in `algae.lua`
- use sprite `26`
- `ap`: algae marker
- algae are solid and can be picked up with the same held-object flow as shrimp/snails
- algae do not move on their own
- if a snail gets close enough to algae, the algae disappears, `tds` drops by `3`, and `sfx(8)` plays
- every `10` days, an algae bloom happens on days `10`, `20`, `30`, etc.
- bloom adds `4 + day/10` algae blocks to each of the first `4` screens
- bloom placement avoids:
  - solid map tiles
  - door/shop tiles
  - tiles within `2` blocks of the player

## Microorganisms

- microorganism logic lives in `micro.lua`
- use sprite strip `59..60`
- `mp`: microorganism marker
- they are background only
- they do not collide
- they do not move once placed

## Moss Balls

- moss ball logic lives in `moss.lua`
- use sprite strip `61..62`
- `mb`: moss ball marker
- they are solid and can be pushed by the player or shrimp
- they do not move on their own
- they animate while moving after being hit
- they are clamped below the top `3` tile rows so they do not enter the HUD area

## Tank

- `ph`: pH
- `amm`: ammonia
- `stab`: stability
- `kh`: carbonate hardness
- `gh`: general hardness
- `tds`: total dissolved solids
- `money`: collected money
- `day`: current day number
- `t`: in-day tick counter, rolling from `0..1499`
- `ct`: coin spawn timer
- `msg`: short timed status-bar message
- `msgc`: message color
- `mt`: message timer
- `pu`, `su`, `du`, `fu`, `gu`, `hu`: one-time shop-unlock sound flags
- `sm`: shop mode (`0` off, `1` normal, `2` plant, `3` shrimp sell, `4` discount, `5` cull, `6` genetic); compare with `>0`
- `ss`: current shop selection (`1..5`)
- `ps`: legacy field, no longer used for plant-shop visibility
- `rx`: red-condition warning count
- `go`: game-over state
- `got`: game-over input lock timer
- `i1`: creature inventory slot at `(2,2)`
- `i2`: item inventory slot at `(3,2)`
- `i1p`: stored snail purity for creature slot
- `i1b`: stored snail base color for creature slot
- `gp`: genetics-shop purity upgrade count
- `gr`: genetics-shop Riley mutation upgrade count
- `gd`: genetics-shop Devil mutation upgrade count
- `f1`: main-shop fancy stock left
- `f4`: discount-shop fancy stock left
- `f5`: fine-shop fancy stock left
- `b2`: plant-shop bacter ae stock left
- `b7`: glass-shop bacter ae stock left
- `m2`: plant-shop moss stock left
- `m4`: discount-shop moss stock left
- one day is currently `1500` updates
- the day clock now rolls every day instead of growing forever, to avoid PICO-8 number overflow
- tank parameter drift is currently applied every `750` updates
- tank parameter status uses:
  - `0`: healthy
  - `1`: unhealthy
  - `2`: dangerous
- `st_col(s)` maps status to text color:
  - healthy: green
  - unhealthy: yellow
  - dangerous: red
- `ph`, `amm`, `kh`, and `gh` display with one decimal digit
- HUD shows `Ct:` count above `day` in dark green
- the `day` HUD text changes by in-day phase:
  - `<375`: green
  - `<750`: yellow
  - `<1125`: orange
  - final stretch: red
- day messages last about `5` seconds and are chosen on new day with this priority:
  - `Algae bloom!` in dark green on bloom days
  - `Calico!` or `Jelly!` in green if a shrimp is born with `sp>=5`
  - `BloodyMary!` or `GreenJade!` in green if a shrimp is born with `sp>=2`
  - `Mutation!` in green if a breeding mutation happened
  - `Shop opened!` in pink on day `12` and day `19`
  - `Old tank` in dark grey on day `18+`
  - `New day` in dark grey otherwise

## Shops

- shop logic lives in `shop.lua`

### Parameter Ranges

- `ph`
  - healthy: `6.8..8.2`
  - unhealthy: outside that, but within `6.3..8.7`
  - dangerous: outside `6.3..8.7`

- `amm`
  - healthy: `0.0`
  - unhealthy: `<0.5`
  - dangerous: `>=0.5`

- `tds`
  - healthy: `100..300`
  - unhealthy: outside that, but within `25..375`
  - dangerous: outside `25..375`

- `kh`
  - healthy: `0..4`
  - unhealthy: `5..7`
  - dangerous: `8+`

- `gh`
  - healthy: `5..12`
  - unhealthy: outside that, but within `3..14`
  - dangerous: outside `3..14`

- `stab`
  - healthy: `>80`
  - unhealthy: `>60`
  - dangerous: `<=60`

### Drift

- every `375` updates:
  - `stab += 15 + moss_balls*2.5`, capped at `100`
- every `750` updates:
  - `amm += (fry + adult_shrimp*2) * (0.025 - microorganisms*0.0025)`, floored at `0`
  - `kh -= 0.1`, floored at `0`
  - `tds += 10`
- old tank syndrome starts on day `18`
  - because stability runs twice per day, each stability tick subtracts:
  - `stab -= (day-17) * 2.5`, capped at `40`
  - because chemistry runs twice per day, each chemistry tick adds:
  - `amm += (day-17) * 0.05`
  - `tds += (day-17) * 2.5`
  - so by day `20`, old tank syndrome adds `+0.3 amm`, `+15 tds`, and `-15 stab` per full day

### Game Over

- if any parameter is red on a new day, `rx += 1`
- if a full day passes with no red parameters, `rx -= 1` until it reaches `0`
- `rx` is shown as red `x` marks above `day`
- game over happens if:
  - `rx >= 3`
  - `stab <= 0`
  - `amm >= 3.0`
  - there are no shrimp or fry left in the tank
- game over screen also shows `score`, which is:
  - `adult shrimp * 10`
  - `max purity * 200`
  - `average adult purity * 100`
  - `snails * 20`
  - `moss balls * 10`
  - `days * 40`
  - `algae * -2`

## Coins

- sprite id: `36`
- frames: `1`
- max active from respawn system: `8`
- spawn band per screen: `x=7..12`, `y=9..10`
- spawn screens: four horizontal screens via `+16 * screen_index`

## Input

- `btn(0)`: left
- `btn(1)`: right
- last horizontal input is tracked for drop direction
- `btn(2)`: up / interact with doors or shops
- `btn(3)+btnp(4)`: hold a nearby shrimp or snail if none is held
- `btn(4)`: inspect a nearby shrimp or snail, drop the held creature, or close dialog
- `btn(5)`: swim upward
- `sfx(2)`: jump / hop sound
- in the shop:
  - `up/down`: move selection
  - `X`: buy selected item and close shop
  - `Z`: close shop

## Dialog

- `sd_a`: currently viewed shrimp/snail, or `nil`
- pressing `Z` near a shrimp or snail opens a dialog
- while dialog is open, normal update/control is paused
- any button press closes the dialog

## Held Creature

- only one creature can be held at a time
- held shrimp draw with sprite `52`
- held shrimp show `*` under `gH` when they are sellable
- held snails draw with sprite `48` one HUD row higher than the other held icons
- held moss balls draw with sprite `20`
- held icon is drawn at tile `(1,2)` on the current screen
- dropping the held creature tries exactly `1` tile left or right based on the last horizontal input
- drop validation uses a slightly inset map hitbox, so near-wall placement is a bit less rigid than full movement collision
- algae ignore that blocked-drop validation so they can be placed quickly without refusal
- if that drop spot is blocked by map or entity collision, the creature stays held

## Shop

- pressing `up` on a door opens the shop
- when a shop becomes available for the first time, it plays `sfx(8)` once
- when there are `10+` shrimp total, the plant shop is visible
- plant shop graphic `12` is drawn at `(25,4)`
- pressing `up` on the plant shop opens the plant menu
- on day `12+`, the shrimp shop graphic `13` is drawn at `(45,5)`
- pressing `up` on the shrimp shop opens the shrimp sell prompt
- if there is a snail in each of the four rooms, the discount shop graphic `14` is drawn at `(33,11)`
- pressing `up` on the discount shop opens the discount menu
- if there is a shrimp with `purity >= 5.0`, the fine shop graphic `15` is drawn at `(30,10)`
- pressing `up` on the fine shop opens the fine menu
- on day `19+`, the genetics shop graphic `31` is drawn at `(53,4)`
- pressing `up` on the genetics shop opens the genetics menu
- if there are `20+` shrimp or the tank is on day `35+`, the glass shop graphic `63` is drawn at `(1,14)`
- pressing `up` on the glass shop opens the glass menu
- purchases only work if `money>=cost`
- creature purchases use slot `(2,2)`
  - `snail` cost `16`, icon `48`
  - `fancy` cost `30`, icon `52`, stock `3`
  - `bacter ae` cost `24`, icon `16`, stock `4`
  - `moss ball` cost `12`, icon `20`, stock `10`
- genetics shop upgrades are immediate and do not use inventory
  - `purity+` cost `20`, count shown in parentheses, adds `+0.2` baby purity
  - `riley+` cost `6`, count shown in parentheses, adds `+1/20` Riley mutation chance
  - `devil+` cost `10`, count shown in parentheses, adds `+1/20` Devil mutation chance
  - genetics purchases play `sfx(3)`
- main-shop and discount-shop `fancy` shrimp each have separate stock of `3`
- when a fancy stock reaches `0`, the row is shown in red and can no longer be bought
- fine-shop `fancy` stock is `3`
- plant-shop `bacter ae` stock is `4`
- glass-shop `bacter ae` stock is `4`
- glass-shop `bacter ae` costs `28`
- when bacter ae reaches `0`, the row is shown in red and can no longer be bought
- plant-shop and discount-shop `moss ball` each have separate stock of `10`
- when a moss stock reaches `0`, the row is shown in red and can no longer be bought
- item purchases use slot `(3,2)`
  - `water change` cost `5`, icon `49`
  - `ro water change` cost `6`, icon `32`
  - `mineral kh+` cost `10`, icon `50`
  - `mineral gh+` cost `6`, icon `51`
  - `ph+` cost `20`, icon `192`
- pressing `Z` in normal play uses inventory when not inspecting/holding a nearby creature
- using a creature item spawns it next to the player and clears the slot
- using `water change`:
  - `stab -= 30`
  - `amm -= 1.0`, floored at `0`
  - `ph` moves `0.1` toward `7.0`
  - `kh -= 1`
  - `gh -= 0.5`
  - `tds -= 30`
- using `ro water change`:
  - `stab -= 30`
  - `ph -= 0.3`
  - `amm -= 2.0`, floored at `0`
  - `kh -= 2`
  - `gh -= 2`
  - `tds -= 120`
- `kh`, `gh`, and `tds` are floored at `0`
- using `mineral kh+`:
  - `stab -= 20`
  - `kh += 3`
  - `gh += 2`
  - `tds += 40`
- using `mineral gh+`:
  - `stab -= 20`
  - `gh += 4`
  - `tds += 25`
- using `ph+`:
  - `ph += 0.1`
- buying `snail` stores random `np=0..1` and random `nb`
- using `snail` spawns that stored snail next to the player
- using `bacter ae` places a microorganism next to the player
- using `moss ball` places a moss ball next to the player
- discount shop sells:
  - `water change` cost `3`
  - `moss ball` cost `10`, stock `10`
  - `fancy` cost `20`
- fine shop sells:
  - `water` cost `1`
  - `fancy` cost `40`, stock `3`
- if no held shrimp is available, the shrimp shop shows `No shrimp to sell`
- shrimp with `sp < 0.5` cannot be sold
- shrimp sell value is `(flr(sp*5) + 2 if sr + 5 if sd) * 2`
- in the shrimp shop:
  - `X`: accept sale
  - `Z`: exit
- using `fancy` spawns an adult shrimp with:
  - `sp=1.0..(0.2 + current max purity)`
  - `sr` 8/20 chance
  - `sd` 2/20 chance
- using `metallic` spawns an adult shrimp with:
  - `sp=2.0`
  - `sr` 8/20 chance
  - `sd` 2/20 chance
- using `devil eyes` spawns an adult shrimp with:
  - `sp=1.5`
  - `sr` 8/20 chance
  - `sd` always true

## Doors

- door tiles checked for interaction:
- `60,5`
- `5,4`
