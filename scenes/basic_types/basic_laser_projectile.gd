extends BasicProjectile

class_name BasicLaserProjectile

@export var speed: float = 800

var _rotation: float
var target_position: Vector2

func _ready() -> void:
	can_be_reflected = true
	
func _process(delta: float) -> void:
	var velocity = direction * speed
	global_position += velocity * delta
	if !is_in_viewport():
		die()
	
func set_initial_target(target_pos: Vector2, target_dir: Vector2):
	target_position = target_pos
	direction = target_dir


func is_in_viewport() -> bool:
	var viewport_rect = get_viewport().get_visible_rect()
	return viewport_rect.has_point(global_position)
	
	
func die() -> void:
	queue_free()
	
func deflect() -> void:
	direction = direction * -1
	can_be_reflected = false
