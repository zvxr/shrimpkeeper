# INSTRUCTIONS.md

## Overview

This is a shrimp tank management game.

- Move around the tank and collect money.
- Buy items and animals from shops.
- Manage water parameters so the tank stays healthy.
- Raise shrimp, breed them, and sell valuable shrimp.

## Title Screen

- The game starts on a title screen
- `Start` begins the tank and creates the player and starting shrimp
- `Help` opens two help pages
- The title screen also shows the saved high score
- Press `X` on the first help page to go to the second
- Press `X` on the second help page to return to the title screen
- Returning from help preselects `Start`

## Time

- Time advances continuously during normal play.
- A new day happens every `1500` updates.
- Some systems happen on every new day.
- Some water changes happen during the day on timed cycles.

## Controls

- Left / Right: move
- `X`: swim upward
- `Up`: enter a shop or interact with a shop tile
- `Z` near a shrimp or snail: inspect it
- `Down + Z` near a shrimp, snail, algae, or moss ball: pick it up if your hands are empty
- `Z` while holding something: drop it on the side of the player based on the last left/right input
- `Z` with no nearby creature and no held creature: use the current inventory item
- On the title screen, use `Up` / `Down` to move between `Start` and `Help`
- On the title and help pages, press `X` to confirm / continue

## Inventory

There are two inventory slots in the task bar.

- Creature slot: used for living things or placeable tank life
- Item slot: used for water and mineral items

General rules:

- Buying something usually fills one of these slots
- If the needed slot is already full, the purchase cannot be made
- Using an item removes it from the slot
- Held creatures are separate from inventory
- You can only hold one picked-up creature or algae at a time

Creature slot examples:

- snail
- fancy shrimp
- bacter ae
- moss ball

Item slot examples:

- water change
- ro water change
- mineral `kH+`
- mineral `gH+`

## Shops And Menus

- Walk onto a shop tile and press `Up` to open that shop
- In shops, use `Up` and `Down` to move the selection
- In most shops:
  - `X` buys the selected item
  - `Z` exits the shop
- In the shrimp sell shop:
  - `X` accepts the sale
  - `Z` exits without selling

## New Day Events

Every new day:

- shrimp age by `1`
- breeding can happen
- red warning marks can go up or down
- a short status message appears in the task bar

Possible day messages:

- `Algae bloom!`
- `Mutation!`
- `Shop opened!`
- `Old Tank Syn`
- `New day`

## Special Days

- Day `12+`: shrimp shop opens
- Every `10` days: algae bloom
- Day `18+`: old tank syndrome begins

## Water Variables

### pH

- `pH` stands for acidity / alkalinity
- healthy range: `6.8` to `8.2`
- warning range: `6.3` to `8.7`
- dangerous outside that range

### Amm

- `Amm` stands for ammonia
- healthy range: exactly `0.0`
- warning range: above `0.0` but below `0.5`
- dangerous at `0.5+`
- game over at `3.0`

### kH

- `kH` stands for carbonate hardness
- healthy range: `0` to `4`
- warning range: `5` to `7`
- dangerous at `8+`
- higher `kH` helps breeding purity

### gH

- `gH` stands for general hardness
- healthy range: `5` to `12`
- warning range: `3` to `14`
- dangerous outside that range

### TDS

- `TDS` stands for total dissolved solids
- healthy range: `100` to `300`
- warning range: `25` to `375`
- dangerous outside that range

### Stability

- `Stab` stands for stability
- healthy above `80`
- warning above `60`
- dangerous at `60` or below
- game over at `0`

## Water Change Over Time

During play, the tank changes on its own.

- stability recovers on a faster cycle
- ammonia, `kH`, `gH`, and `TDS` change on a chemistry cycle
- old tank syndrome makes ammonia and `TDS` rise faster after day `18`
- old tank syndrome also reduces stability more each day after it begins

## Shops

There are several shops in the tank.

### Main Shop

- always available
- accessed from the normal door tiles
- sells the core water items and basic livestock
- includes water change, `kH+`, `gH+`, snail, and fancy shrimp

### Plant Shop

- unlocks permanently once there are `8` adult shrimp
- sells plant-side support items
- includes `RO Water Change`, `Bacter AE`, and moss ball

### Shrimp Shop

- appears on day `12+`
- used to sell held shrimp
- turns a held shrimp into money based on purity and traits

### Extra Fancy Shop

- appears on day `19+`
- sells premium shrimp options
- includes fancy shrimp, metallic shrimp, and devil-eyes shrimp

### Discount Shop

- appears when there is at least `1` snail in each of the `4` rooms
- this is based on the current tank state, not a permanent unlock
- sells discounted versions of a few existing items
- includes water change, moss ball, and fancy shrimp

### Culling Shop

- appears when there is at least `1` adult shrimp with purity `>= 2.0`
- this is based on the current tank state, not a permanent unlock
- removes low-purity natural shrimp for a fee
- can cull fry or adults with purity below `0.5`

## Shrimp

- Fry grow into adults at age `5`
- Adult shrimp can breed if conditions are good enough
- Shrimp value depends on purity and traits
- Better shrimp can be sold for more money

## Other Tank Life

### Snails

- snails wander slowly
- they can eat algae

### Microorganisms

- microorganisms reduce ammonia growth
- they do not collide and stay in place

### Moss Balls

- moss balls can be pushed around
- they help stability recover

### Algae

- algae blooms happen every `10` days
- algae blocks are solid
- algae can be picked up
- algae disappears when a nearby snail reaches it

## Losing

The game ends if any of these happen:

- ammonia reaches `3.0`
- stability reaches `0`
- bad water remains red long enough to build `3` red `x` marks
- there are no shrimp left in the tank
