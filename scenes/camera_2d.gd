extends Camera2D


var shake_intensity = 0.0
var shake_duration = 0.0
var shake_decay = 5.0  # How fast the shake decays (higher value = faster)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if shake_duration > 0:
		shake_duration -= delta
		
		# Apply a random offset to the camera based on the shake intensity
	var shake_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
	position += shake_offset

		# Decrease intensity over time (decay effect)
	shake_intensity = lerp(shake_intensity, 0.0, shake_decay * delta)
		
	if shake_duration <= 0:
		position = Vector2.ZERO

# Call this function to trigger a screen shake
func start_screen_shake(intensity: float, duration: float):
	shake_intensity = intensity
	shake_duration = duration
