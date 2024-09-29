extends Node

enum EnemyType {
	REGULAR_ENEMY = 0,
	ELITE_ENEMY = 1,
	BOMB_ENEMY = 2
}

enum BossType {
	FIRST_BOSS = 0
}

const PLAYER_POSITION: Vector2 = Vector2(741, 735)
const RADIUS: int = 500
const BOSS_RADIUS: int = 575

@onready var enemy_types = [
	preload("res://scenes/enemies/simple_enemy.tscn"),
	preload("res://scenes/enemies/elite_enemy.tscn"),
	preload("res://scenes/enemies/bomb_drone_enemy.tscn")
]

@onready var boss_types = [
	preload("res://scenes/first_boss/first_boss.tscn")
]


func spawn_enemy(enemy_type: int, radius: int = RADIUS) -> void:
	var random_angle = randf() * TAU  # TAU is 2 * PI (full circle)
	var spawn_x = PLAYER_POSITION.x + radius * cos(random_angle)
	var spawn_y = PLAYER_POSITION.y + radius * sin(random_angle)
	var enemy_instance = enemy_types[enemy_type].instantiate()
	enemy_instance.position = Vector2(spawn_x, spawn_y)
	if enemy_instance is BasicEnemy:
		enemy_instance.center_position = PLAYER_POSITION
	get_tree().current_scene.call_deferred("add_child", enemy_instance)
	
	
func spawn_boss(boss_type: int) -> void:
	var spawn_x = PLAYER_POSITION.x
	var spawn_y = PLAYER_POSITION.y - BOSS_RADIUS
	var boss_instance = boss_types[boss_type].instantiate()
	boss_instance.position = Vector2(spawn_x, spawn_y)
	get_tree().current_scene.call_deferred("add_child", boss_instance)
	
	
