extends Node


enum ProjectileType {
	BASIC_PROJECTILE = 0,
	ELITE_PROJECTILE = 1,
	BOSS_BIG_LASER = 2
}

#@onready var projectile_types = [
	#preload("res://scenes/projectiles/basic_projectile.tscn"),
	#preload("res://scenes/projectiles/elite_projectile.tscn"),
	#preload("res://scenes/projectiles/boss_large_laser_projectile.tscn").
	#preload("res://scenes/basic_types/basic_laser_projectile.tscn")
#]


enum LaserType {
	PLAYER_LASER = 0, 
	BASIC_ENEMY_LASER = 1
}

@onready var laser_types = [
	preload("res://scenes/projectiles/player_laser.tscn"),
	preload("res://scenes/projectiles/basic_enemy_laser.tscn")
	
]

#func spawn_projectile(projectile_type: int, target: Vector2, self_position: Vector2) -> Area2D:
	#var spawned_projectile = projectile_types[projectile_type].instantiate()
	#get_tree().root.add_child(spawned_projectile)
	#var direction = (target - self_position).normalized()
	#spawned_projectile.rotation = direction.angle() + deg_to_rad(90)
	#spawned_projectile.global_position = self_position
	#spawned_projectile.add_to_group("projectile")
	#spawned_projectile.set_target(target)
	#return spawned_projectile

func spawn_laser(laser_type: int, target_position: Vector2, start_position: Vector2) -> void:
	var laser_projectile = laser_types[laser_type].instantiate()
	get_tree().current_scene.add_child(laser_projectile)
	var direction = (target_position - start_position).normalized()
	laser_projectile.rotation = direction.angle() + deg_to_rad(90)
	laser_projectile.global_position = start_position
	laser_projectile.set_initial_target(target_position, direction)
	
