extends Node2D

@export var image: PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var my_pos = sprite_2d.position
	var needed_vector = mouse_pos - my_pos
	var angl = needed_vector.angle()
	sprite_2d.rotation = angl + deg_to_rad(90)
	


func _on_timer_timeout() -> void:
	print("1341234")
	var player_position = sprite_2d.global_position
		# Generate a random angle in radians
	var random_angle = randf() * TAU  # TAU is 2 * PI (full circle)

		# Calculate the position on the circle
	var spawn_x = player_position.x + 400 * cos(random_angle)
	var spawn_y = player_position.y + 400 * sin(random_angle)

	var spawn_position = Vector2(spawn_x, spawn_y)

		# Instance the enemy and set its position
	var enemy_instance: Enemy = image.instantiate()
	enemy_instance.global_position = spawn_position
	enemy_instance.center_position = player_position
	enemy_instance.current_angle = random_angle

		# Add the enemy to the scene
	add_child(enemy_instance)
	print("Enemy spawned at: ", spawn_position)
