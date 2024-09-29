extends Node

class_name BossStateMachine


var boss: FirstBoss
var current_state: BossState
var states = {}

func _ready():
	states[GameManager.STATE_LASER_ATTACK] = preload("res://scripts/boss_state_machine/laser_attack_state.gd").new()
	states[GameManager.STATE_IDLE] = preload("res://scripts/boss_state_machine/boss_idle_state.gd").new()
	states[GameManager.STATE_ROCKET_ATTACK] = preload("res://scripts/boss_state_machine/boss_rocket_state.gd").new()
	change_state(GameManager.STATE_IDLE)

func change_state(new_state_name: String):
	if current_state:
		print(new_state_name)
		current_state.exit_state()
	current_state = states[new_state_name]
	current_state.boss = boss
	current_state.enter_state()
	
func set_boss(boss_instance: FirstBoss):
	boss = boss_instance

func _process(delta):
	if current_state:
		current_state.update(delta)
