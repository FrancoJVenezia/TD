# AGENTS.md

Instrucciones para agentes de código (Codex, Claude Code y otros) que trabajen en este repositorio.

## Proyecto

"TD" es un tower defense 3D en **Godot 4.7** (Forward Plus, Jolt Physics, D3D12 en Windows), escrito en **GDScript**. Usar siempre sintaxis y APIs de Godot 4.7; nunca patrones de Godot 3.

- Editor: Godot de Steam, en `F:\Steam\steamapps\common\Godot Engine\godot.windows.opt.tools.64.exe`.
- Escena principal: `res://scenes/levels/level_01.tscn`.
- `.godot/` es la caché del editor: no se edita ni se commitea.

## Tareas

Las tareas del juego viven en el tablero **TD** de Trello: https://trello.com/b/T7cqMdTz/td. Los commits usan los códigos de las tarjetas (`[F0.1]`, `f1.2`…). Antes de implementar algo, leer la tarjeta correspondiente.

## Arquitectura

- **Autoloads** (`scripts/autoload/`):
  - `EventBus`: señales globales de combate, economía, oleadas y estado de juego. Los sistemas se comunican por acá, no con referencias directas.
  - `Wallet`, `MetaProgress`, `GameState`: todavía vacíos.
- **Núcleo** (`scripts/core/`):
  - `StatBlock` + `Modifier` (modos FLAT / PCT_ADD / PCT_MULT, con duración opcional) para todos los stats modificables. `MOVE_SPEED` y `FIRE_RATE` tienen un piso del 10 % del valor base.
  - `Health`: vida, armadura y muerte.
  - `DamageInfo`.
  - `StatId`.
- **Datos como Resources** (`scripts/data/` define las clases, `data/` tiene las instancias `.tres`): `EnemyData`, `TowerData` y `TowerLevelData`. El balance se edita en los `.tres`, no en el código.
- **Enemigos**: `Enemy extends PathFollow3D`. Se instancian como hijos del `Path3D` del nivel, no del `Level`.
- **Capas de física**: `world`, `enemy`, `tower_range`, `projectile`, `build_slot`.

## Convenciones

- `fire_rate` se mide en **disparos por segundo**.
- Comentarios en español.
- Tipado estático en GDScript (`:=`, tipos en parámetros y retornos).
- Antes de crear un commit o hacer push, pedir aprobación explícita al usuario y esperar su respuesta en otro mensaje. La aprobación automática de la aplicación no reemplaza esta confirmación.

## Herramientas instaladas

- **Skills** (`.agents/skills/` para Codex, `.claude/skills/` para Claude; son las mismas):
  - GodotPrompter: 59 skills de Godot. Empezar por `using-godot-prompter`.
  - awesome-gamedev-agent-skills: 74 skills multi-motor, entre ellas `tower-defense`. `router` elige la adecuada.
  - `godot`, de haxqer: scripts para inspeccionar, validar, testear y exportar.
- **Subagentes** de GodotPrompter: `.codex/agents/` y `.claude/agents/`.
- **MCP**:
  - `godot` (Coding-Solo/godot-mcp): lanza el editor y corre el juego. Configurado en `.codex/config.toml` y `.mcp.json`.
  - `godot-ai`: plugin en `addons/godot_ai/` que da acceso al editor abierto. Se configura desde su dock en Godot.
  - Trello.
- Licencias de terceros: `.agents/THIRD_PARTY/`.
