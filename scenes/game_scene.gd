extends Node2D

class_name GameScene

@export var radius: float = 200  # Radius of the circle
@export var circle_color: Color = Color(1, 1, 1, 1)  # White color
@onready var background: Sprite2D = $Background

var rotation_speed: float = PI/16
var current_angle: float = 0  
var enemies_defeated_count: int = 0      

func _ready() -> void:
	SignalBus.enemy_destroyed.connect(on_enemy_destroyed)


func on_enemy_destroyed(points: int) -> void:
	enemies_defeated_count = enemies_defeated_count + 1
	#if enemies_defeated_count % 10 == 0:
		#SignalBus.enemy_group_defeated.emit(10)
	if enemies_defeated_count > 1:
		SignalBus.enemy_group_defeated.emit(15)
		
