extends Node2D

@export var radius: float = 200  # Radius of the circle
@export var circle_color: Color = Color(1, 1, 1, 1)  # White color
@onready var background: Sprite2D = $Background

var rotation_speed: float = PI/16
var current_angle: float = 0  
var enemies_defeated_count: int = 0      

func _ready() -> void:
	SignalBus.enemy_destroyed.connect(on_enemy_destroyed)

# Called every frame to ensure the circle is redrawn
func _process(delta: float) -> void:
	current_angle += rotation_speed * delta
	# Apply the rotation to the background sprite
	background.rotation = current_angle

# This function automatically gets called when the node needs to be redrawn
func _draw() -> void:
		# Draw the circle around the player's global position
	draw_circle($Player.global_position, 500, Color.BLACK, false)


func on_enemy_destroyed(points: int) -> void:
	enemies_defeated_count = enemies_defeated_count + 1
	if enemies_defeated_count % 10 == 0:
		SignalBus.enemy_group_defeated.emit(10)
		
