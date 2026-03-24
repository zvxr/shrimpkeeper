# DOCS.md

## Coordinates

- `x`, `y`: world position in map tiles
- screen size: `16x16` tiles
- used world span: `0,0` to `63,15`

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
  - `false`: green/yellow line
- `sr`: riley
- `sd`: devil eyes
- `st`: movement timer
- `sdx`: desired horizontal direction
- `so`: orientation (`0` left, `1` right)
- `sj`: remaining hop-chain jumps
- `ha`: currently held creature, or `nil`

### Age

- fry: `0..7`
- adult: `8+`
- fry use sprite strip `53..56` as `1x1`
- adults use sprite strip starting at `37` with `+2` frame steps as `2x1`
- fry hitbox is currently smaller than the full tile
- adult hitbox is currently narrower/flatter than the full sprite

### Defaults

- `sa=8`
- `sp=0.5`
- `sb`: 50/50 random
- `sr`: 30/70 random
- `sd`: 10/90 random

### Initial Spawn

- initial world no longer places one fixed adult shrimp
- it now creates `4` fry shrimp
- initial fry age is randomized in `3..6`
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
  - all tank parameters healthy
  - 50% success roll
- success creates one fry with `sa=1`
- baby values:
  - `sp`: random from `(lowest-0.2)` to `(highest+0.2)`
  - `sb`: shared parent base color
  - `sr`: `TT -> T`, `TF -> 50% T`, `FF -> F`
  - `sd`: `TT -> T`, `TF -> 50% T`, `FF -> F`
- mutations:
  - `1/10`: `sp += 1`
  - `1/20`: `sr=true`
  - `1/100`: `sd=true`
  - if any mutation happens, `bm` shows `Mutation!`

### Palette Mapping

- base sprite colors:
- legs `4`
- body `5`
- back `6`
- belly `7`
- eyes `14`

- `body`
  - `sp>=2`: `[2/3]`
  - `sp>=0.7`: `[8/11]`
  - `sp>=0.5`: `[9/10]`
  - else `[4/5]`

- `back`
  - `sp>=2`: `[2/3]`
  - `sp>=0.9`: `[8/11]`
  - `sp>=0.6`: `[9/10]`
  - else `[4/5]`

- `belly`
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
  - `false`: green/yellow line
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
- snails wander slowly and mostly idle
- the initial world creates `1` snail with `np=0.5` and random `nb`

## Tank

- `ph`: pH
- `amm`: ammonia
- `stab`: stability
- `kh`: carbonate hardness
- `gh`: general hardness
- `tds`: total dissolved solids
- `money`: collected money
- `day`: current day number
- `t`: tank update tick counter
- `ct`: coin spawn timer
- `bm`: short breeding debug text, including `Mutation!`
- `sm`: whether the shop menu is open
- `ss`: current shop selection (`1..5`)
- `i1`: creature inventory slot at `(2,2)`
- `i2`: item inventory slot at `(3,2)`
- `i1p`: stored snail purity for creature slot
- `i1b`: stored snail base color for creature slot
- one day is currently `1500` updates
- tank parameter drift is currently applied every `300` updates (`5` times/day)
- tank parameter status uses:
  - `0`: healthy
  - `1`: unhealthy
  - `2`: dangerous
- `st_col(s)` maps status to text color:
  - healthy: green
  - unhealthy: yellow
  - dangerous: red

### Parameter Ranges

- `ph`
  - healthy: `6.8..8.2`
  - unhealthy: outside that, but within `6.3..8.7`
  - dangerous: outside `6.3..8.7`

- `amm`
  - healthy: `0.0`
  - unhealthy: `<0.4`
  - dangerous: `>=0.4`

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

- every `300` updates:
  - `stab += 10`, capped at `100`
  - `amm += fry + adult_shrimp*2 + snails/2`
  - `kh -= 0.2`, then `+0.1` per snail
  - `tds += 10`

## Coins

- sprite id: `36`
- frames: `1`
- max active from respawn system: `8`
- spawn band per screen: `x=7..12`, `y=9..10`
- spawn screens: four horizontal screens via `+16 * screen_index`

## Input

- `btn(0)`: left
- `btn(1)`: right
- `btn(2)`: up / interact with doors
- `btn(3)+btnp(4)`: hold a nearby shrimp or snail if none is held
- `btn(4)`: inspect a nearby shrimp or snail, drop the held creature, or close dialog
- `btn(5)`: swim upward
- `sfx(2)`: jump / hop sound
- in the shop:
  - `up/down`: move selection
  - `Z`: buy selected item
  - `X`: close shop

## Dialog

- `sd_a`: currently viewed shrimp/snail, or `nil`
- pressing `Z` near a shrimp or snail opens a dialog
- while dialog is open, normal update/control is paused
- any button press closes the dialog

## Held Creature

- only one creature can be held at a time
- held shrimp draw with sprite `52`
- held snails draw with sprite `48`
- held icon is drawn at tile `(1,2)` on the current screen
- dropping the held creature places it next to the player

## Shop

- pressing `up` on a door opens the shop
- purchases only work if `money>=cost`
- creature purchases use slot `(2,2)`
  - `snail` cost `20`, icon `48`
  - `fancy` cost `30`, icon `52`
- item purchases use slot `(3,2)`
  - `water change` cost `5`, icon `49`
  - `mineral kh+` cost `10`, icon `50`
  - `mineral gh+` cost `10`, icon `51`
- pressing `Z` in normal play uses inventory when not inspecting/holding a nearby creature
- using a creature item spawns it next to the player and clears the slot
- using `water change`:
  - `stab -= 50`
  - `amm /= 2`
  - `kh -= 1`
  - `gh -= 1`
  - `tds -= 50`
- using `mineral kh+`:
  - `stab -= 20`
  - `kh += 2`
  - `gh += 2`
  - `tds += 50`
- using `mineral gh+`:
  - `stab -= 20`
  - `gh += 2`
  - `tds += 25`
- buying `snail` stores random `np=0..1` and random `nb`
- using `snail` spawns that stored snail next to the player
- using `fancy` spawns an adult shrimp with:
  - `sp=0.7..1.2`
  - `sr` 50% chance
  - `sd` 10% chance

## Doors

- door tiles checked for interaction:
- `60,5`
- `5,4`
