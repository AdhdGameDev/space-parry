extends BossState


func enter_state() -> void:
	print("rocket barage")
	boss.start_rocket_barage()
	SignalBus.rocket_barage_ended.connect(_on_barage_ended)
	

func _on_barage_ended() -> void:
	boss.state_machine.change_state(GameManager.STATE_IDLE)
