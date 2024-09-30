extends BasicProjectile

class_name BigBossLaser

var start_position: Vector2
var is_dead: bool = false
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	speed = 250
	start_position = global_position
	SignalBus.player_moved.connect(_on_player_moved)
	SignalBus.boss_moved.connect(_on_boss_moved)
	
func _physics_process(delta):
	if !is_dead:
		# Calculate the direction toward the target
		var target_direction
		if reflected:
			target_direction = (start_position - global_position).normalized()
			speed = 1000
		else:
			target_direction = (target_position - global_position).normalized()
		# Smoothly update the current direction to the target direction
		velocity = velocity.lerp(target_direction * speed, 0.1)  # 0.1 controls how smooth the adjustment is
		rotation = velocity.angle() + deg_to_rad(-90)
		# Move the projectile
		global_position += velocity * delta

func _on_player_moved(pos: Vector2) -> void:
	if !reflected:
		set_target(pos)
		
func _on_boss_moved(pos: Vector2) -> void:
	if reflected:
		set_target(pos)
		
		
func explode() -> void:
	
	speed == 0
	is_dead = true
	print("explosion started")
	sprite_2d.visible = false
	explosion.visible = true
	explosion.play("explosion")
	
func die() -> void:
	pass


func _on_explosion_animation_finished() -> void:
	print("explosion finished")
	super.die()
