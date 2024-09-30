extends BossState


func enter_state() -> void:
	boss.energy_beam_attack()
	SignalBus.boss_beam_finished.connect(_on_beam_ended)

func _on_beam_ended() -> void:
	boss.state_machine.change_state(GameManager.STATE_IDLE)
