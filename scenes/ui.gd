extends Control

@onready var score_label: Label = $CanvasLayer/MarginContainer/HBoxContainer/ScoreLabel
var current_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_destroyed.connect(_on_enemy_destroyed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_destroyed(points: int) -> void:
	current_score += points
	score_label.text = str(current_score)
