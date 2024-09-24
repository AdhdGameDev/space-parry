extends BasicProjectile


@export var initial_velocity: float = 100  # Starting speed of the projectile
@export var max_velocity: float = 800  # Max speed limit for the projectile
@export var acceleration: float = 50  # How much the speed increases per second

var direction: Vector2 = Vector2(0, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = direction * initial_velocity
	$AnimatedSprite2D.play("rocket")

func flip() -> void:
	$AnimatedSprite2D.flip_v = true


func _physics_process(delta):
	# Increase velocity by acceleration each frame, capped at max_velocity
	var speed = velocity.length()  # Get the current speed
	speed += acceleration * delta  # Increase the speed steadily
	speed = clamp(speed, 0, max_velocity)  # Ensure the speed doesn't exceed max_velocity
	
	# Update the velocity vector with the new speed, keeping the direction the same
	velocity = direction.normalized() * speed

	# Move the projectile using the updated velocity
	position += velocity * delta
