extends Control

@onready var game_over_label: Label = $CanvasLayer/MarginContainer/GameOverLabel
@onready var score_label: Label = $CanvasLayer/MarginContainer/ScoreLabel
var current_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_destroyed.connect(_on_enemy_destroyed)
	SignalBus.player_death.connect(_on_player_death)
	game_over_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_destroyed(points: int) -> void:
	current_score += points
	score_label.text = str(current_score)
	
	
func _on_player_death() -> void:
	game_over_label.visible = true
	get_tree().paused = true
