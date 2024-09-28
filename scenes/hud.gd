extends Control

@onready var boss_health_bar: TextureProgressBar = $CanvasLayer/BossHealthBar
@onready var game_over_label: Label = $CanvasLayer/MarginContainer/GameOverLabel
@onready var score_label: Label = $CanvasLayer/MarginContainer/ScoreLabel
var current_score: int = 0
var current_boss_health: int
@onready var healthbar: Control = $CanvasLayer/Healthbar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_destroyed.connect(_on_enemy_destroyed)
	SignalBus.player_death.connect(_on_player_death)
	SignalBus.boss_damaged.connect(_on_boss_damaged)
	SignalBus.player_damaged.connect(_on_player_damaged)
	SignalBus.on_level_one_complete.connect(_on_level_one_complete)
	game_over_label.visible = false
	boss_health_bar.max_value = GameManager.first_boss_health
	boss_health_bar.value = boss_health_bar.max_value
	current_boss_health = boss_health_bar.max_value

func _on_player_damaged(damage: int) -> void:
	# Iterate over the damage amount
	for i in range(damage):
		# Loop through the children of the healthbar to find the next visible heart to remove
		for j in range(healthbar.get_child_count()):
			var heart = healthbar.get_child(j)
			if heart.visible:
				heart.visible = false
				break  # Stop after hiding one heart for each damage point
		
	
func _on_enemy_destroyed(points: int) -> void:
	current_score += points
	score_label.text = str(current_score)
	if current_score > GameManager.LEVEL_ONE_NEEDED_SCORE:
		SignalBus.on_level_one_complete.emit()
	
	
func _on_player_death() -> void:
	game_over_label.visible = true
	get_tree().paused = true

func _on_boss_damaged(damage: int) -> void:
	current_boss_health -= damage
	boss_health_bar.value = current_boss_health

func _on_level_one_complete() -> void:
	pass
