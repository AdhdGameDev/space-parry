extends Area2D

class_name Enemy
var center_position: Vector2
var current_angle: float
var rotation_speed: float = 0.4
var direction: int = 1

var change_direction: bool = false



func _ready() -> void:
	
	$Timer.wait_time = randf_range(1, 4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_angle += rotation_speed * delta * direction
	var new_x = center_position.x + 400 * cos(current_angle)
	var new_y = center_position.y + 400 * sin(current_angle)
	global_position = Vector2(new_x, new_y)


func _on_timer_timeout() -> void:
	var stop = randi_range(0, 5)
	if stop == 5 or stop == 0:
		print("chance")
		rotation_speed = 0
	else:
		rotation_speed = randf_range(0.1, 1.0)
	direction = direction * -1
	
