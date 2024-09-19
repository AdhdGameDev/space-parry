extends Area2D

class_name Player

@export var enemy: PackedScene
@onready var player_image: Sprite2D = $Sprite2D
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var deflect_area: Area2D = $DeflectArea
@onready var deflect_animation: AnimatedSprite2D = $deflect_animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_spawn_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var needed_vector = mouse_pos - position
	var angl = needed_vector.angle()
	player_image.rotation = angl + deg_to_rad(90)
	# Sync the deflect area rotation with the player
	deflect_area.rotation = player_image.rotation
	if Input.is_action_just_pressed("Deflect"):
		trigger_deflect_effect()
		try_to_deflect()
	
func try_to_deflect() -> void:
	print(deflect_area.get_overlapping_areas()) 
	for projectile in deflect_area.get_overlapping_areas():
		var current_projectile: BasicProjectile = projectile
		var new_velocity = (get_global_mouse_position() - global_position).normalized() * 100
		print(new_velocity)
		current_projectile.velocity = new_velocity
		
func trigger_deflect_effect() -> void:
	# Ensure the animation is reset and starts playing from the beginning
	deflect_animation.play("deflect")
	
	# Calculate position in front of the player
	var deflect_position = global_position + Vector2(cos(player_image.rotation), sin(player_image.rotation)) * 50
	deflect_animation.global_position = deflect_position
	
	# Optional: Sync rotation of the effect with the player's rotation
	deflect_animation.rotation = player_image.rotation
	
	
func _on_enemy_spawn_timer_timeout() -> void:
	var player_position = player_image.global_position
		# Generate a random angle in radians
	var random_angle = randf() * TAU  # TAU is 2 * PI (full circle)

		# Calculate the position on the circle
	var spawn_x = player_position.x + 400 * cos(random_angle)
	var spawn_y = player_position.y + 400 * sin(random_angle)

	var spawn_position = Vector2(spawn_x, spawn_y)

		# Instance the enemy and set its position
	var enemy_instance: Enemy = enemy.instantiate()
	enemy_instance.global_position = spawn_position
	enemy_instance.center_position = player_position
	enemy_instance.current_angle = random_angle

		# Add the enemy to the scene
	add_child(enemy_instance)
	
	
	
