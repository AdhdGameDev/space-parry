extends Node2D

class_name LevelOne

@onready var background: Sprite2D = $Background

var enemies_defeated_count: int = 0      

func _ready() -> void:
	SignalBus.enemy_destroyed.connect(on_enemy_destroyed)
	
	
func _process(delta: float) -> void:
	background.rotate(PI/16 * delta)


func on_enemy_destroyed(points: int) -> void:
	enemies_defeated_count = enemies_defeated_count + 1
	if enemies_defeated_count % 7 == 0:
		EnemyFactory.spawn_enemy(EnemyFactory.EnemyType.ELITE_ENEMY)
		


func _on_regular_enemy_spawn() -> void:
	EnemyFactory.spawn_enemy(EnemyFactory.EnemyType.REGULAR_ENEMY)


func _on_on_bomb_enemy_spawn_timer_timeout() -> void:
	EnemyFactory.spawn_enemy(EnemyFactory.EnemyType.BOMB_ENEMY, 900)
