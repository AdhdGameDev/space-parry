extends Node

class_name PlayerAttackComponent

@export var player: Player
@export var laser_cooldown: float = 0.5
@export var laser_sound: AudioStreamPlayer

var laser_offset: Vector2 = Vector2(0, -40)

func fire_laser() -> void:
	if not player.can_laser:
		return

	player.can_laser = false
	get_tree().create_timer(laser_cooldown).timeout.connect(_on_laser_cooldown)
	var laser_global_position = player.new_design_ship.to_global(laser_offset)

	ProjectileFactory.spawn_laser(ProjectileFactory.LaserType.PLAYER_LASER, player.get_global_mouse_position(), laser_global_position)

	laser_sound.play()

func _on_laser_cooldown():
	player.can_laser = true
