#!/usr/bin/env python3
from pathlib import Path
import re
import sys

RX = re.compile(r"\.\.\.|[A-Za-z_][A-Za-z0-9_]*|\d+\.\d+|\d+|==|~=|!=|<=|>=|\+=|-=|\*=|/=|\.\.|[(){}\[\],.:;+\-*/%^#=<>]")


def flat_lua(root: Path, cart: str):
    text = (root / cart).read_text()
    out = []
    in_lua = False
    for line in text.splitlines():
        if line.strip() == "__lua__":
            in_lua = True
            continue
        if in_lua and line.startswith("__"):
            break
        if not in_lua:
            continue
        if line.startswith("#include "):
            inc = line.split(None, 1)[1].strip()
            out.append(f"-- #include {inc}")
            out.extend((root / inc).read_text().splitlines())
        else:
            out.append(line)
    return out


def strip_comments(lines):
    out = []
    for line in lines:
        out.append(line.split("--", 1)[0] if "--" in line else line)
    return out


def count_tokens(text):
    return len(RX.findall(text))


def main():
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")
    cart = sys.argv[2] if len(sys.argv) > 2 else "shrimpkeeper.p8"
    lines = flat_lua(root, cart)
    code_lines = strip_comments(lines)
    flat = "\n".join(lines) + "\n"
    flat_code = "\n".join(code_lines) + "\n"
    print("flat_lines", len(lines))
    print("flat_chars", len(flat))
    print("rough_lex_tokens", count_tokens(flat))
    print("rough_code_tokens", count_tokens(flat_code))


if __name__ == "__main__":
    main()
