extends Node


enum ProjectileType {
	BASIC_PROJECTILE = 0,
	ELITE_PROJECTILE = 1
}

@onready var projectile_types = [
	preload("res://scenes/projectiles/basic_projectile.tscn"),
	preload("res://scenes/projectiles/elite_projectile.tscn")
]

func spawn_projectile(projectile_type: int, target: Vector2, self_position: Vector2) -> void:
	var spawned_projectile = projectile_types[projectile_type].instantiate()
	get_tree().root.add_child(spawned_projectile)
	var direction = (target - self_position).normalized()
	spawned_projectile.rotation = direction.angle() + deg_to_rad(90)
	spawned_projectile.global_position = self_position
	spawned_projectile.add_to_group("projectile")
	spawned_projectile.set_target(target)
