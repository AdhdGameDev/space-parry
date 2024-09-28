extends Node

signal enemy_destroyed(points: int)
signal player_death
signal player_damaged(damage: int)
signal enemy_group_defeated(count: int)
signal player_collision_hit(global_position: Vector2)
signal boss_damaged(damage: int)
signal rocket_launched
signal coordinates_recevied(position: Vector2)
signal rocked_exploded(position: Vector2)
signal on_level_one_complete
signal player_moved(position: Vector2)
