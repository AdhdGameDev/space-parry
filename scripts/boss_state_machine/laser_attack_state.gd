extends BossState


func enter_state() -> void:
	boss.laser_attack()
	SignalBus.first_boss_barage_ended.connect(_on_barage_ended)
	

func _on_barage_ended() -> void:
	boss.state_machine.change_state(GameManager.STATE_IDLE)
