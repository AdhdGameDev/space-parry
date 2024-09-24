extends Area2D

class_name BasicEnemy

@export var explosion_particle: PackedScene
var center_position: Vector2
var current_angle: float
@export var rotation_speed: float = 0.4
var direction: int = 1

var change_direction: bool = false
var radius: float = 500
var is_turned: bool = false
var is_stopped: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)

	
func move(delta: float) -> void:
	current_angle += rotation_speed * delta * direction
	var new_x = center_position.x + radius * cos(current_angle)
	var new_y = center_position.y + radius * sin(current_angle)
	if is_turned and !is_stopped:
		rotation = lerp_angle(rotation, current_angle + PI, 0.1)  # Flip 180 degrees smoothly
	elif !is_stopped:
		rotation = lerp_angle(rotation, current_angle, 0.1)  # Rotate smoothly to the original angle

	global_position = Vector2(new_x, new_y)
	
	
func explode() -> void:
	var explosion = explosion_particle.instantiate()
	explosion.global_position = self.global_position
	get_tree().root.add_child(explosion)  # Add it to the scene root, not as a child of Enemy
	explosion.emitting = true
