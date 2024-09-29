extends BossState

var can_move: bool = false

func enter_state() -> void:
	can_move = true
	
func update(delta) -> void:
	if can_move:
		boss.move(delta)

	# Check if the boss has reached the edge of the screen
	if boss.global_position.x <= 150:
		boss.global_position.x = 150  # Ensure boss stays within bounds
		boss.last_move_direction = Vector2.RIGHT  # Change direction to move right
		_change_to_random_attack_state()

	elif boss.global_position.x >= 1300:
		boss.global_position.x = 1300  # Ensure boss stays within bounds
		boss.last_move_direction = Vector2.LEFT  # Change direction to move left
		_change_to_random_attack_state() 


func _change_to_random_attack_state() -> void:
	# Randomly select a state
	var random_value = randi() % 2  # Generates either 0 or 1
	if random_value == 0:
		boss.state_machine.change_state(GameManager.STATE_LASER_ATTACK)  # Transition to LaserAttack state
	else:
		boss.state_machine.change_state(GameManager.STATE_ROCKET_ATTACK)  # Transition to RocketAttack state
