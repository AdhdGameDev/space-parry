extends Area2D

class_name Player

@export var enemy: PackedScene
@export var eliteEnemy: PackedScene
@export var laser: PackedScene
@export var shield_explosion: PackedScene

@onready var deflect_area: Area2D = $DeflectArea

@onready var deflect_timer_buffer: Timer = $DeflectTimerBuffer
@onready var laser_cooldown_timer: Timer = $LaserCooldownTimer
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var shield_timer: Timer = $ShieldTimer
@onready var shield_cooldown_timer: Timer = $ShieldCooldownTimer

@onready var new_design_ship: AnimatedSprite2D = $NewDesignShip
@onready var engine_effect: AnimatedSprite2D = $NewDesignShip/EngineEffect
@onready var laser_gun: AnimatedSprite2D = $NewDesignShip/LaserGun

@onready var camera_2d: Camera2D = $Camera2D
@onready var shield: Sprite2D = $Shield
@onready var ship_collision: CollisionShape2D = $ShipCollision

@export var health: int = 15
@export var enemy_max_count: int = 5
var current_enemy_count: int = 0

var shield_active: bool = false
var shield_cooldown_passed: bool = true
var can_laser: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shield.visible = false
	SignalBus.enemy_destroyed.connect(enemy_destroyed)
	SignalBus.player_collision_hit.connect(on_player_collision_hit)
	SignalBus.enemy_group_defeated.connect(on_group_defeated)
	enemy_spawn_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	engine_effect.play("default")
	var mouse_pos = get_global_mouse_position()
	var needed_vector = mouse_pos - position
	var angl = needed_vector.angle()
	 # Smoothly rotate towards the target angle using lerp_angle()
	new_design_ship.rotation = lerp_angle(new_design_ship.rotation, angl + deg_to_rad(90), 2 * PI * delta)
	# Sync the deflect area rotation with the player
	deflect_area.rotation = new_design_ship.rotation
	if Input.is_action_just_pressed("Deflect"):
		deflect_timer_buffer.start()
		try_to_deflect()
	if Input.is_action_just_pressed("LaserFirePlayer"):
		if can_laser:
			open_fire(new_design_ship.rotation)
	if Input.is_action_just_pressed("Shield"):
		activate_shield()
	
			
func enemy_destroyed(points: int) -> void:
	current_enemy_count = current_enemy_count - 1
	
func activate_shield() -> void:
	if shield_cooldown_passed:
		shield_cooldown_passed = !shield_cooldown_passed
		shield_cooldown_timer.start()
		shield_active = !shield_active
		shield.visible = !shield.visible
		ship_collision.scale = ship_collision.scale * 2
		shield_timer.start()
	
func try_to_deflect() -> void:
	if deflect_timer_buffer.time_left > 0:
		for projectile in deflect_area.get_overlapping_areas():
			if !projectile.is_in_group("player") and !projectile.is_in_group("laser"):
				var current_projectile: BasicProjectile = projectile
				current_projectile.reflected = true
				deflect_area.modulate = Color.BLACK
				var new_velocity = (get_global_mouse_position() - global_position).normalized() * 600
				current_projectile.velocity = new_velocity
				overcharge()
		
func overcharge() -> void:
	#for child in player_image.get_children():
		#child.visible = !child.visible
	#$AnimationPlayer.play("overcharge")
	laser_cooldown_timer.wait_time = laser_cooldown_timer.wait_time / 4

	
func open_fire(rotation: float) -> void:
	laser_cooldown_timer.start()
	can_laser = !can_laser
	var laser_instance = laser.instantiate()
	var forward_offset = Vector2(0, -40).rotated(new_design_ship.rotation)  
	laser_instance.global_position = new_design_ship.position + forward_offset
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - new_design_ship.global_position).normalized()
	laser_instance.rotation = direction.angle() + deg_to_rad(90)
	
	# Set the laser's velocity in that direction (you may need to adjust the speed)
	laser_instance.velocity = direction * 600  # Adjust speed as needed
	laser_instance.add_to_group("laser")
	add_child(laser_instance)
	$AudioStreamPlayer.play()
	laser_gun.play("fire")

func _on_enemy_spawn_timer_timeout() -> void:
	if enemy_max_count > current_enemy_count:
		var player_position = new_design_ship.global_position
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
	
		current_enemy_count = current_enemy_count + 1



func _on_laser_cooldown_timer_timeout() -> void:
	can_laser = !can_laser


func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group("laser"):
		if !shield_active:
			health = health - 1
			camera_2d.start_screen_shake(5, 2)
			if health == 0:
				SignalBus.player_death.emit()
			var next_frame = new_design_ship.frame + 1
			new_design_ship.set_frame_and_progress(next_frame, 1)
			
func on_player_collision_hit(global_pos: Vector2) -> void:
	var shield_exp = shield_explosion.instantiate()
	shield_exp.global_position = to_local(global_pos)
	shield_exp.play("explosion")
	add_child(shield_exp)
	
func _on_shield_end() -> void:
	shield_active = false
	shield.visible = !shield.visible
	ship_collision.scale = ship_collision.scale / 2


func _on_shield_cooldown_passed() -> void:
	shield_cooldown_passed = !shield_cooldown_passed
	
func on_group_defeated(count: int) -> void:
	if count % 10 == 0:
		var player_position = new_design_ship.global_position
		# Generate a random angle in radians
		var random_angle = randf() * TAU  # TAU is 2 * PI (full circle)

		# Calculate the position on the circle
		var spawn_x = player_position.x + 500 * cos(random_angle)
		var spawn_y = player_position.y + 500 * sin(random_angle)

		var spawn_position = Vector2(spawn_x, spawn_y)

		# Instance the enemy and set its position
		var elite_enemy_instance = eliteEnemy.instantiate()
		elite_enemy_instance.global_position = spawn_position
		elite_enemy_instance.center_position = player_position
		elite_enemy_instance.current_angle = random_angle
		call_deferred("add_child", elite_enemy_instance)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.stop()
	laser_cooldown_timer.wait_time = laser_cooldown_timer.wait_time * 4
