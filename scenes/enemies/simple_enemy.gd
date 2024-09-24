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
	var spawned_projectile: BasicProjectile = projectile.instantiate()
	get_tree().root.add_child(spawned_projectile)  # Add it to the scene root
	
	var direction = (center_position - global_position).normalized()
	spawned_projectile.rotation = direction.angle() + deg_to_rad(90)
	spawned_projectile.global_position = self.global_position
	spawned_projectile.add_to_group("projectile")
	spawned_projectile.set_target(center_position)

func _on_enemy_hit(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		var current_projectile: BasicProjectile = area as BasicProjectile
		if current_projectile.reflected:
			SignalBus.enemy_destroyed.emit(10)
			explode()
			queue_free()  # Enemy is hit by a reflected projectile
			current_projectile.queue_free()  # Optionally remove the projectile
	elif area.is_in_group("laser"):
		SignalBus.enemy_destroyed.emit(10)
		queue_free()
		explode()
	elif area.is_in_group("enemy"):
		direction = direction * -1
		rotation = current_angle + deg_to_rad(90)
