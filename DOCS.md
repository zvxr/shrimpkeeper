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
  - `false`: yellow/green line
- `sr`: riley
- `sd`: devil eyes
- `st`: movement timer
- `sdx`: desired horizontal direction
- `so`: orientation (`0` left, `1` right)
- `sj`: remaining hop-chain jumps
- `ha`: currently held creature, or `nil`

### Age

- fry: `0..6`
- adult: `7+`
- on each new day, shrimp age by `1`
- once a shrimp is `30+` days old, each new day has a `50%` chance it dies and disappears
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
- initial fry colors are `2` red-line and `2` yellow-line
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
  - no tank parameter is dangerous/red
  - 50% success roll
- success creates one fry with `sa=1`
- baby values:
  - `sp`: random from `(lowest-0.2)` to `(highest+0.2)`, then `+ tank.kh/4`
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
- snails wander slowly and mostly idle
- snails reduce `gh` by `0.05` each water cycle

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
- `sm`: shop mode (`0` off, `1` normal, `2` plant, `3` shrimp sell, `4` discount); compare with `>0`
- `ss`: current shop selection (`1..5`)
- `ps`: whether the plant shop is unlocked
- `rx`: red-condition warning count
- `go`: game-over state
- `i1`: creature inventory slot at `(2,2)`
- `i2`: item inventory slot at `(3,2)`
- `i1p`: stored snail purity for creature slot
- `i1b`: stored snail base color for creature slot
- one day is currently `1500` updates
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

- every `750` updates:
  - `stab += 30 + moss_balls*5`, capped at `100`
  - `amm += (fry - snails + adult_shrimp*2) * (0.025 - microorganisms*0.005)`, floored at `0`
  - `kh -= 0.1`, floored at `0`
  - `gh += moss_balls * 0.05 - snails * 0.05`, floored at `0`
  - `tds += 10`

### Game Over

- if any parameter is red on a new day, `rx += 1`
- if a full day passes with no red parameters, `rx -= 1` until it reaches `0`
- `rx` is shown as red `x` marks above `day`
- game over happens if:
  - `rx >= 3`
  - `stab <= 0`
  - `amm >= 3.0`

## Coins

- sprite id: `36`
- frames: `1`
- max active from respawn system: `8`
- spawn band per screen: `x=7..12`, `y=9..10`
- spawn screens: four horizontal screens via `+16 * screen_index`

## Input

- `btn(0)`: left
- `btn(1)`: right
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
- held snails draw with sprite `48`
- held icon is drawn at tile `(1,2)` on the current screen
- dropping the held creature places it next to the player

## Shop

- pressing `up` on a door opens the shop
- once `8` adult shrimp exist, the plant shop unlocks permanently
- plant shop graphic `12` is drawn at `(25,4)`
- pressing `up` on the plant shop opens the plant menu
- on day `10+`, the shrimp shop graphic `13` is drawn at `(45,5)`
- pressing `up` on the shrimp shop opens the shrimp sell prompt
- if there is a snail in each of the four rooms, the discount shop graphic `14` is drawn at `(33,11)`
- pressing `up` on the discount shop opens the discount menu
- purchases only work if `money>=cost`
- creature purchases use slot `(2,2)`
  - `snail` cost `20`, icon `48`
  - `fancy` cost `30`, icon `52`
  - `bacter ae` cost `24`, icon `16`
  - `moss ball` cost `12`, icon `20`
- item purchases use slot `(3,2)`
  - `water change` cost `5`, icon `49`
  - `ro water change` cost `6`, icon `32`
  - `mineral kh+` cost `10`, icon `50`
  - `mineral gh+` cost `6`, icon `51`
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
  - `tds -= 80`
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
- buying `snail` stores random `np=0..1` and random `nb`
- using `snail` spawns that stored snail next to the player
- using `bacter ae` places a microorganism next to the player
- using `moss ball` places a moss ball next to the player
- discount shop sells:
  - `water change` cost `4`
  - `moss ball` cost `10`
  - `fancy` cost `20`
- if no held shrimp is available, the shrimp shop shows `No shrimp to sell`
- shrimp with `sp < 1` cannot be sold
- shrimp sell value is `(flr(sp*5) + 2 if sr + 5 if sd) * 2`
- in the shrimp shop:
  - `X`: accept sale
  - `Z`: exit
- using `fancy` spawns an adult shrimp with:
  - `sp=0.7..1.2`
  - `sr` 50% chance
  - `sd` 10% chance

## Doors

- door tiles checked for interaction:
- `60,5`
- `5,4`
