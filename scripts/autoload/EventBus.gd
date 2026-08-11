extends Node

# --- Combate ---
signal enemy_died(enemy, killer_tags: Array)
signal enemy_reached_base(enemy)
signal base_damaged(current: float, max_hp: float)
signal base_destroyed()

# --- Economía ---
signal balance_changed(currency: StringName, value: int)

# --- Oleadas ---
signal wave_started(index: int)
signal wave_cleared(index: int)
signal all_waves_cleared()

# --- Juego ---
signal game_state_changed(from: int, to: int)
