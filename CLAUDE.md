# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A single-file app (`seiko_diver.html`) — an interactive catalog for Seiko Prospex automatic dive watches. No build tooling or package.json. Open directly in a browser.

## Architecture

**Data** — `watches` array at the top. Each entry has: `cat` (collection slug), `name`, `sub` (specs), `refs` (model numbers), `wr`/`wrColor` (water resistance), `price`/`priceNote`.

**Images** — `images/<ref>/front.jpg|png` and `images/<ref>/profile.jpg|png` where `<ref>` is `refs[0].toLowerCase()`. `WatchImg` tries `.jpg` first, then `.png`, then shows a placeholder. Adding a watch = adding a data entry + dropping images in the right folder.

**UI** — `WatchThumbnail` renders front and profile images side by side (350×350px each). `App` holds two state values: `cat` (active category filter) and `modal` (currently enlarged image, `{ w, view }`). All UI labels are in English.

## Conventions

- All styling is inline React style objects — no CSS files or utility classes.
- Dark theme base: `#0a0a0f` background, `#c9a84c` gold accent.
- Water resistance colors: green `#4ade80` (300m), blue `#60a5fa` (200m), purple `#e879f9` (600m+).
