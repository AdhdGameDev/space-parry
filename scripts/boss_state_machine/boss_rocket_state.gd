extends BossState


func enter_state() -> void:
	boss.ship.frame_changed.connect(_on_new_rocket_launched)
	boss.start_rocket_barage()

func exit_state() -> void:
	boss.end_rocket_barage()
	boss.ship.frame_changed.disconnect(_on_new_rocket_launched)
	
	
func _on_new_rocket_launched() -> void:
	if boss.ship.frame in boss.shot_markers:
		print(boss.shot_markers[boss.ship.frame])
		fire_rocket(boss.shot_markers[boss.ship.frame])

	if boss.ship.frame == 15:
		boss.state_machine.change_state(GameManager.STATE_IDLE)
		
func fire_rocket(marker: Marker2D) -> void:
	var fired_rocket = boss.rocket.instantiate()
	boss.get_tree().root.add_child(fired_rocket)
	SignalBus.rocket_launched.emit()
	boss.rocket_start_sound.play()
	var direction = Vector2.DOWN
	fired_rocket.rotation = direction.angle() + deg_to_rad(90)
	fired_rocket.global_position = marker.global_position
	fired_rocket.add_to_group("projectile")
