extends Control

@onready var start_game_label: Label = $MarginContainer/StartGameLabel
var my_scene = preload("res://scenes/game_scene.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Deflect"):
		var scene_instance = my_scene.instantiate()
		get_tree().change_scene_to_packed(my_scene)
