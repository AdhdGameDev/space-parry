extends BossState

var laser_barage_duration_timer

func enter_state() -> void:
	boss.can_fire_regular_laser = true
	laser_barage_duration_timer = boss.laser_barage_timer_end
	var laser_interval_attack_timer = boss.laser_attack_timer
	laser_barage_duration_timer.timeout.connect(_on_laser_barage_duration_timeout)
	laser_interval_attack_timer.timeout.connect(_on_laser_interval_attack_timer)
	boss.laser_attack()
	
func _on_laser_barage_duration_timeout() -> void:
	launch_projectile(ProjectileFactory.ProjectileType.BOSS_BIG_LASER)
	boss.state_machine.change_state(GameManager.STATE_IDLE)
	
func exit_state() -> void:
	boss.can_fire_regular_laser = false
	laser_barage_duration_timer.timeout.disconnect(_on_laser_barage_duration_timeout)
	boss.laser_attack_timer.timeout.disconnect(_on_laser_interval_attack_timer)

	
func _on_laser_interval_attack_timer() -> void:
	if boss.can_fire_regular_laser:
		launch_projectile(ProjectileFactory.ProjectileType.BASIC_PROJECTILE)
		
func launch_projectile(projectile_type: ProjectileFactory.ProjectileType) -> void:
	ProjectileFactory.spawn_projectile(projectile_type, boss.player.position, boss.position)
	
