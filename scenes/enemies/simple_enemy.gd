extends BasicEnemy  # Inherit from BasicEnemy

@onready var body: Sprite2D = $Body

func _ready() -> void:
	$Timer.wait_time = randf_range(1, 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)  # Call the inherited move function

func _on_timer_timeout() -> void:
	var stop = randi_range(0, 5)
	if stop == 5 or stop == 0:
		is_stopped = true
		rotation_speed = 0
		rotation = current_angle + deg_to_rad(90)
		spawn_projectile()
	else:
		is_stopped = false
		rotation_speed = randf_range(0.1, 1.0)
	direction = direction * -1
	is_turned = !is_turned

func spawn_projectile() -> void:
	# Calculate a forward offset based on the current angle of movement.
	var forward_offset = Vector2(cos(current_angle), sin(current_angle)) * -40  # Offset in front of the enemy based on the direction of movement

	# Calculate the global position for spawning the laser.
	var laser_global_position = global_position + forward_offset

	# Spawn the laser at the calculated global position.
	ProjectileFactory.spawn_laser(ProjectileFactory.LaserType.BASIC_ENEMY_LASER, center_position, laser_global_position)




func _on_enemy_hit(area: Area2D) -> void:
	if area is BasicProjectile:
		die(GameManager.BASIC_ENEMY_SCORE)
		area.queue_free()
	elif area.is_in_group("enemy"):
		direction = direction * -1
		rotation = current_angle + deg_to_rad(90)
