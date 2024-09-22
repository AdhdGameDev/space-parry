extends Area2D

var center_position: Vector2
var current_angle: float
@export var rotation_speed: float = 0.4
var direction: int = 1

var change_direction: bool = false
var radius: float = 500
var is_turned: bool = false
var is_stopped: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_angle += rotation_speed * delta * direction
	var new_x = center_position.x + radius * cos(current_angle)
	var new_y = center_position.y + radius * sin(current_angle)
	if is_turned and !is_stopped:
		rotation = lerp_angle(rotation, current_angle + PI, 0.1)  # Flip 180 degrees smoothly
	elif !is_stopped:
		rotation = lerp_angle(rotation, current_angle, 0.1)  # Rotate smoothly to the original angle

	global_position = Vector2(new_x, new_y)
	
