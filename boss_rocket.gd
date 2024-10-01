extends BasicProjectile


@export var initial_velocity: float = 150  # Starting speed of the projectile
@export var max_velocity: float = 800  # Max speed limit for the projectile
@export var acceleration: float = 100  # How much the speed increases per second

@onready var rocket: AnimatedSprite2D = $Rocket
@onready var aiming_timer: Timer = $AimingTimer
@onready var explosion: AnimatedSprite2D = $Explosion

var target: Vector2
var target_coordinates_set: bool = false
var aimed: bool = false
var velocity


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.coordinates_recevied.connect(_on_coordinates_received)
	direction = Vector2(0, 1)
	velocity = direction * initial_velocity
	rocket.play("rocket")
	aiming_timer.start()

func flip() -> void:
	rocket.flip_v = true


func _physics_process(delta: float) -> void:
	# Increase velocity by acceleration each frame, capped at max_velocity
	var speed = velocity.length()  # Get the current speed
	speed += acceleration * delta  # Increase the speed steadily
	speed = clamp(speed, 0, max_velocity)  # Ensure the speed doesn't exceed max_velocity
	
	# Calculate direction only once
	if aimed and target_coordinates_set:
		direction = (target - position).normalized()
	
	velocity = direction * speed
	
	# Smoothly adjust rotation towards the target if aimed
	if aimed and target_coordinates_set:
		var angle = get_angle_to(target)
		rotation = lerp_angle(rotation, angle + deg_to_rad(-90), 0.1)  # Smoothly rotate to target
	
	# Move the projectile using the updated velocity
	if global_position.distance_to(target) > 5:
		position += velocity * delta
	else:
		explode()


func explode() -> void:
	SignalBus.rocked_exploded.emit(global_position)
	rocket.visible = false
	explosion.visible = true
	explosion.play("default")
	

func _on_aiming_timer_timeout() -> void:
	aimed = true
	
func _on_coordinates_received(position: Vector2) -> void:
	if !target_coordinates_set:
		target = position
		target_coordinates_set = true
	


func _on_explosion_animation_finished() -> void:
	queue_free()


#func _on_area_entered(area: Area2D) -> void:
	#if area is Player:
		#explode()
		#SignalBus.player_death.emit()
