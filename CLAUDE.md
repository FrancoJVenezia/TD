# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

"TD" is a Godot 4.7 project (Forward Plus renderer, Jolt Physics, D3D12 rendering driver on Windows). It is currently an empty project skeleton — no scenes, scripts, or assets have been added yet beyond the default icon and `project.godot`.

## Development

This project is edited and run through the Godot 4.7 editor, not via a CLI build/test toolchain. There are no build, lint, or test commands configured yet (no scripts, no test framework, no CI).

- Open the project by pointing the Godot 4.7 editor at `project.godot`.
- `.godot/` is the editor's local cache/import directory — it is git-ignored and should never be edited or committed.

As scenes, scripts (GDScript/C#), and tests are added, update this file with the actual commands and architecture (e.g. how to run the game, how to run any test suite, and the scene/node structure once it exists).
