extends Area2D

class_name Player

@export var enemy: PackedScene
@export var laser: PackedScene

@onready var player_image: Sprite2D = $Sprite2D
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var deflect_area: Area2D = $DeflectArea
@onready var deflect_timer_buffer: Timer = $DeflectTimerBuffer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_spawn_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var needed_vector = mouse_pos - position
	var angl = needed_vector.angle()
	 # Smoothly rotate towards the target angle using lerp_angle()
	player_image.rotation = lerp_angle(player_image.rotation, angl + deg_to_rad(90), 2 * PI * delta)
	# Sync the deflect area rotation with the player
	deflect_area.rotation = player_image.rotation
	if Input.is_action_just_pressed("Deflect"):
		deflect_timer_buffer.start()
		try_to_deflect()
	if Input.is_action_just_pressed("LaserFirePlayer"):
		open_fire(player_image.rotation)
	
func try_to_deflect() -> void:
	if deflect_timer_buffer.time_left > 0:
		for projectile in deflect_area.get_overlapping_areas():
			if !projectile.is_in_group("player"):
				var current_projectile: BasicProjectile = projectile
				current_projectile.reflected = true
				deflect_area.modulate = Color.BLACK
				var new_velocity = (get_global_mouse_position() - global_position).normalized() * 600
				current_projectile.velocity = new_velocity
		
func open_fire(rotation: float) -> void:
	var laser_instance = laser.instantiate()
	var forward_offset = Vector2(0, -40).rotated(player_image.rotation)  
	laser_instance.global_position = player_image.position + forward_offset
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - player_image.global_position).normalized()
	laser_instance.rotation = direction.angle() + deg_to_rad(90)
	
	# Set the laser's velocity in that direction (you may need to adjust the speed)
	laser_instance.velocity = direction * 600  # Adjust speed as needed
	laser_instance.add_to_group("laser")
	add_child(laser_instance)
	$AudioStreamPlayer.play()

func _on_enemy_spawn_timer_timeout() -> void:
	var player_position = player_image.global_position
		# Generate a random angle in radians
	var random_angle = randf() * TAU  # TAU is 2 * PI (full circle)

		# Calculate the position on the circle
	var spawn_x = player_position.x + 500 * cos(random_angle)
	var spawn_y = player_position.y + 500 * sin(random_angle)

	var spawn_position = Vector2(spawn_x, spawn_y)

		# Instance the enemy and set its position
	var enemy_instance: Enemy = enemy.instantiate()
	enemy_instance.global_position = spawn_position
	enemy_instance.center_position = player_position
	enemy_instance.current_angle = random_angle

		# Add the enemy to the scene
	add_child(enemy_instance)
	
	
	
