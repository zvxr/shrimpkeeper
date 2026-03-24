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

- shrimp are currently the only `2x1` ent
- current setup:
- `k=37`
- `frames=4`
- `fs=2`
- `sw=2`
- `sh=1`
- `w=0.9`
- `h` currently uses the base default unless changed later

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
