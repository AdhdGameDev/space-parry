extends Area2D

var direction: Vector2
var speed: float = 800
var velocity: Vector2
var _rotation: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = (get_global_mouse_position() - global_position).normalized()
	velocity = direction * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += velocity * delta
