extends BasicProjectile


@export var initial_velocity: float = 75  # Starting speed of the projectile
@export var max_velocity: float = 800  # Max speed limit for the projectile
@export var acceleration: float = 35  # How much the speed increases per second
@onready var aiming_timer: Timer = $AimingTimer

var player: Player



var aimed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2(0, 1)
	player = get_tree().get_nodes_in_group("player")[0]
	velocity = direction * initial_velocity
	$AnimatedSprite2D.play("rocket")
	aiming_timer.start()

func flip() -> void:
	$AnimatedSprite2D.flip_v = true


func _physics_process(delta):
	# Increase velocity by acceleration each frame, capped at max_velocity
	var speed = velocity.length()  # Get the current speed
	speed += acceleration * delta  # Increase the speed steadily
	speed = clamp(speed, 0, max_velocity)  # Ensure the speed doesn't exceed max_velocity
	if aimed and !reflected:
		var direction = (player.position - position).normalized()
		var angle = player.get_angle_to(self.position)
		velocity = direction * speed
		rotation = angle + deg_to_rad(-90)
	# Update the velocity vector with the new speed, keeping the direction the same
	else: velocity = direction.normalized() * speed

	# Move the projectile using the updated velocity
	position += velocity * delta


func _on_aiming_timer_timeout() -> void:
	aimed = true
