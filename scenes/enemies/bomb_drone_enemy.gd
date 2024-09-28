extends BasicProjectile

class_name BombEnemy

@onready var explosion: AnimatedSprite2D = $Explosion
@onready var bomb: AnimatedSprite2D = $bomb
@onready var explosion_radius: Area2D = $ExplosionRadius

func _ready() -> void:
	SignalBus.player_moved.connect(_on_player_moved)
	speed = 50

	
func _on_player_moved(pos: Vector2) -> void:
	set_target(pos)


func _physics_process(delta):
	var target_direction = (target_position - global_position).normalized()
	rotation = target_direction.angle() + deg_to_rad(90)
	global_position += velocity * delta
	


func _on_area_entered(area: Area2D) -> void:
	explode()
	
	
func explode() -> void:
	speed = 0
	bomb.visible = false
	explosion.visible = true
	explosion.play()
	for area in explosion_radius.get_overlapping_areas():
		if area is Player:
			SignalBus.player_damaged.emit(3)
		if area is BasicEnemy:
			area.die(GameManager.BASIC_ENEMY_SCORE)



func _on_explosion_animation_finished() -> void:
	SignalBus.enemy_destroyed.emit(GameManager.BOMB_ENEMY_SCORE)
	queue_free()
