extends BasicProjectile
 
class_name EliteProjectile

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("pulse")
