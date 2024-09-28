extends Control

@onready var start_game_label: Label = $MarginContainer/StartGameLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Deflect"):
		GameManager.load_first_level_scene()
