extends Control

@onready var start_game_label: Label = $MarginContainer/StartGameLabel
var level_one = preload("res://scenes/game_scene.tscn")
var level_one_boss = preload("res://scenes/first_boss/first_boss_arena.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Deflect"):
		var level_one = level_one_boss.instantiate()
		get_tree().change_scene_to_packed(level_one_boss)
