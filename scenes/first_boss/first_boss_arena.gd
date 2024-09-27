extends GameScene

@onready var rocket_ld: Marker2D = $RocketLD
@onready var rocket_lu: Marker2D = $RocketLU
@onready var rocket_ru: Marker2D = $RocketRU
@onready var rocket_rd: Marker2D = $RocketRD

const MINIMUM_DISTANCE: float = 150.0
var previous_strikes: Array[Dictionary] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyFactory.spawn_boss(EnemyFactory.BossType.FIRST_BOSS)
	SignalBus.rocket_launched.connect(_on_rocket_launched)

func _on_rocket_launched() -> void:
	SignalBus.coordinates_recevied.emit(calculate_rocket_target())

func calculate_rocket_target() -> Vector2:
	var x_min = min(rocket_ld.global_position.x, rocket_lu.global_position.x, rocket_ru.global_position.x, rocket_rd.global_position.x)
	var x_max = max(rocket_ld.global_position.x, rocket_lu.global_position.x, rocket_ru.global_position.x, rocket_rd.global_position.x)
	
	var y_min = min(rocket_ld.global_position.y, rocket_lu.global_position.y, rocket_ru.global_position.y, rocket_rd.global_position.y)
	var y_max = max(rocket_ld.global_position.y, rocket_lu.global_position.y, rocket_ru.global_position.y, rocket_rd.global_position.y)
	
	var new_position = Vector2.ZERO
	var max_attempts = 10
	var attempt_count = 0
	while attempt_count < max_attempts:
		attempt_count += 1
		var random_x = randf_range(x_min, x_max)
		var random_y = randf_range(y_min, y_max)
		new_position = Vector2(random_x, random_y)
		var is_too_close = false
		
		for strike in previous_strikes:
			if strike["position"].distance_to(new_position) < MINIMUM_DISTANCE:
				is_too_close = true
				break
		
		if !is_too_close:
			break
	
	# Append strike with timestamp
	previous_strikes.append({"position": new_position, "time": 0.0})
	
	draw_danger_zone(new_position)
	return new_position

# Function to draw the danger zone
func draw_danger_zone(position: Vector2) -> void:
	queue_redraw()  # Trigger a redraw of the scene

# Draw red danger circles at strike positions
func _draw() -> void:
	for strike in previous_strikes:
		draw_circle(strike["position"], 75.0, Color(1, 0, 0))  # Draw red circles for each strike position

# Remove the strike after 1 second
func _process(delta: float) -> void:
	for i in range(previous_strikes.size() - 1, -1, -1):
		var strike = previous_strikes[i]
		strike["time"] += delta
		if strike["time"] > 1.5:
			previous_strikes.remove_at(i)
	queue_redraw()  # Redraw to update the scene when strikes are removed
