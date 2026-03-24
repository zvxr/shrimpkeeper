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

### Age

- fry: `0..7`
- adult: `8+`
- fry use sprite strip `53..56` as `1x1`
- adults use sprite strip starting at `37` with `+2` frame steps as `2x1`

### Defaults

- `sa=8`
- `sp=0.5`
- `sb`: 50/50 random
- `sr`: 30/70 random
- `sd`: 10/90 random

### Initial Spawn

- initial world no longer places one fixed adult shrimp
- it now creates `4` fry shrimp
- fry spawn in the coin box on horizontal screens `2` and `3`
- spawn band: `x=7..12 + 16*(1 or 2)`, `y=9..10`

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

## Coins

- sprite id: `36`
- max active from respawn system: `8`
- spawn band per screen: `x=7..12`, `y=9..10`
- spawn screens: four horizontal screens via `+16 * screen_index`

## Input

- `btn(0)`: left
- `btn(1)`: right
- `btn(2)`: up / interact with doors
- `btn(5)`: swim upward

## Doors

- door tiles checked for interaction:
- `60,5`
- `5,4`
