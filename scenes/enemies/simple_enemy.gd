extends BasicEnemy  # Inherit from BasicEnemy

@export var projectile: PackedScene

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
	ProjectileFactory.spawn_projectile(ProjectileFactory.ProjectileType.BASIC_PROJECTILE, center_position, global_position)

func _on_enemy_hit(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		var current_projectile: BasicProjectile = area as BasicProjectile
		if current_projectile.reflected:
			die(GameManager.BASIC_ENEMY_SCORE)
			current_projectile.queue_free()  # Optionally remove the projectile
	elif area.is_in_group("laser"):
		die(GameManager.BASIC_ENEMY_SCORE)
	elif area.is_in_group("enemy"):
		direction = direction * -1
		rotation = current_angle + deg_to_rad(90)
