extends Area2D

class_name Enemy

@export var projectile: PackedScene

var center_position: Vector2
var current_angle: float
var rotation_speed: float = 0.4
var direction: int = 1

var change_direction: bool = false
var radius: float = 500
@onready var live_timer: Timer = $LiveTimer



func _ready() -> void:
	live_timer.start()
	$Timer.wait_time = randf_range(1, 4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_angle += rotation_speed * delta * direction
	var new_x = center_position.x + radius * cos(current_angle)
	var new_y = center_position.y + radius * sin(current_angle)
	global_position = Vector2(new_x, new_y)


func _on_timer_timeout() -> void:
	var stop = randi_range(0, 5)
	if stop == 5 or stop == 0:
		rotation_speed = 0
		spawn_projectile()
	else:
		rotation_speed = randf_range(0.1, 1.0)
	direction = direction * -1

func spawn_projectile() -> void:
	var spawned_projectile: BasicProjectile = projectile.instantiate()
	get_tree().root.add_child(spawned_projectile)  # Add it to the scene root, not as a child of Enemy
	spawned_projectile.global_position = self.global_position
	spawned_projectile.set_target(center_position)


func _on_live_timer_timeout() -> void:
	queue_free()
