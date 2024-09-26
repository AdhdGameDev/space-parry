extends Control

@onready var boss_health_bar: TextureProgressBar = $CanvasLayer/BossHealthBar
@onready var game_over_label: Label = $CanvasLayer/MarginContainer/GameOverLabel
@onready var score_label: Label = $CanvasLayer/MarginContainer/ScoreLabel
var current_score: int = 0
var current_boss_health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_destroyed.connect(_on_enemy_destroyed)
	SignalBus.player_death.connect(_on_player_death)
	SignalBus.boss_damaged.connect(_on_boss_damaged)
	game_over_label.visible = false
	boss_health_bar.max_value = GameManager.first_boss_health
	boss_health_bar.value = boss_health_bar.max_value
	current_boss_health = boss_health_bar.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_destroyed(points: int) -> void:
	current_score += points
	score_label.text = str(current_score)
	
	
func _on_player_death() -> void:
	game_over_label.visible = true
	get_tree().paused = true

func _on_boss_damaged(damage: int) -> void:
	current_boss_health -= damage
	boss_health_bar.value = current_boss_health
