extends Area2D

class_name BasicProjectile
# Speed of the projectile
var speed = 250
var velocity = Vector2.ZERO

var reflected: bool = false

# Reference to the player (target)
var target_position = Vector2.ZERO

# Set the target to move towards (you can pass the player's position)
func set_target(target_pos: Vector2):
	target_position = target_pos
	# Calculate the direction towards the target and normalize it
	velocity = (target_position - global_position).normalized() * speed

func _physics_process(delta):
	# Move the projectile towards the target
	global_position += velocity * delta
	
	


func _on_player_ara_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		SignalBus.player_collision_hit.emit(self.global_position)
		queue_free()
	
