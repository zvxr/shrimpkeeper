# AGENTS.md

## Context
Target: **PICO-8 (Lua)**  
Goals: small code, low token usage, fast iteration, simple patterns.

## Core rules
- Prefer **simple tables + functions** over OOP or abstractions.
- Avoid metatables, inheritance, or frameworks unless explicitly needed.
- Keep identifiers short but readable.
- Minimize token-heavy patterns; favor simpler equivalents.
- Preserve behavior; make minimal changes.

## Token strategy
- Be mindful of the **8192 token limit**.
- Prefer concise patterns over generic/expandable ones.
- **Use multiple files/includes freely** for organization (file boundaries do not increase token cost).

## PICO-8 specifics
- Sprite ids (0–255) index the sprite sheet (16x16 tiles of 8x8).
- Use `spr(n,x,y,w,h,flip_x,flip_y)` for multi-tile sprites.
- Animation strips:
  - 1-tile frames → `+1`
  - 2-tile frames → `+2`
- Use `pal()` for recoloring and `palt()` for transparency.
- Reset palette with `pal()` after drawing unless intentional.

## Graphics guidance
- Use **placeholder colors** for body regions; recolor via `pal()`.
- Prefer flipping (`flip_x`) over duplicating sprites.
- Keep animation frames contiguous on the sprite sheet.

## Code style
- Keep update/draw loops straightforward.
- Favor small helpers over deep indirection.
- Keep movement/physics lightweight.
- Do not add comments to code files; keep documentation in `DOCS.md` instead.
- Always update `DOCS.md` when variables, controls, systems, or file responsibilities change.

## Avoid by default
- classes / metatables
- ECS or heavy architecture
- unnecessary duplication of sprites (use palette swaps instead)
