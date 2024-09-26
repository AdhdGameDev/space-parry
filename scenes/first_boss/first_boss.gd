extends Area2D

class_name FirstBoss

@export var rocket: PackedScene

@onready var ship: AnimatedSprite2D = $Ship
@onready var engine: AnimatedSprite2D = $Ship/Engine
@onready var energy_beam_animation: AnimationPlayer = $EnergyBeamAnimation
@onready var energy_beam: AnimatedSprite2D = $Ship/EnergyBeam
@onready var shield: AnimatedSprite2D = $Ship/Shield

@onready var energy_beam_timer: Timer = $EnergyBeamTimer
@onready var shield_timer: Timer = $ShieldTimer
@onready var move_timer: Timer = $MoveTimer
@onready var laser_attack_timer: Timer = $LaserAttackTimer
@onready var rocket_timer: Timer = $RocketTimer


var player: Area2D
var current_health: int
var defence_active: bool = false

# Dictionary to map frames to shot markers
@onready var shot_markers = {
	5: $ShotOne,
	7: $ShotFour,
	9: $ShotTwo,
	11: $ShotFive,
	13: $ShotThree,
	15: $ShotSix
}

var rocket_barage_active: bool = false
var energy_beam_active: bool = false
var is_moved_recently: bool = true

var last_move_direction: Vector2
var speed: float  = GameManager.first_boss_speed


func _ready() -> void:
	print("Start position")
	print(global_position)
	current_health = GameManager.first_boss_health
	engine.play("engine")
	$BeamArea/BeamCollision.disabled = true
	player = get_tree().get_nodes_in_group("player")[0]
	
func _process(delta: float) -> void:
	if !is_moved_recently:
		move(delta)
	if Input.is_action_just_pressed("Shield") and not rocket_barage_active:
		#start_rocket_barage()
		laser_attack()
	#if Input.is_action_just_pressed("ui_accept") and not energy_beam_active:
		#energy_beam_active = true
		#energy_beam_attack()
		
		
func move(delta: float) -> void:
	var screen_width = 1200
	position += speed * last_move_direction * delta

	if global_position.x < 0:
		print(position)
		position.x = 0
		last_move_direction = Vector2.RIGHT
	elif global_position.x > screen_width:
		position.x = screen_width
		last_move_direction = Vector2.LEFT
	

		
		
func laser_attack() -> void:
	if !rocket_barage_active:
		ProjectileFactory.spawn_projectile(ProjectileFactory.ProjectileType.BASIC_PROJECTILE, player.position, position)
	
func start_rocket_barage() -> void:
	rocket_barage_active = true
	ship.play("fire")

# Fire a rocket from the marker
func fire_rocket(marker: Marker2D) -> void:
	var fired_rocket = rocket.instantiate()
	get_tree().root.add_child(fired_rocket)
	
	# Set rocket position and rotation
	var direction = Vector2.DOWN
	fired_rocket.rotation = direction.angle() + deg_to_rad(90)
	fired_rocket.global_position = marker.global_position
	fired_rocket.add_to_group("projectile")

# Handle animation frame changes
func _on_ship_frame_changed() -> void:
	if rocket_barage_active and ship.frame in shot_markers:
		fire_rocket(shot_markers[ship.frame])

	# End barrage when the last frame (15) is reached
	if ship.frame == 15:
		speed = GameManager.first_boss_speed
		end_rocket_barage()

func end_rocket_barage() -> void:
	rocket_barage_active = false
	ship.play("idle")
	
func energy_beam_attack() -> void:
	energy_beam.play()
	energy_beam_timer.start()
	energy_beam_animation.play("energy_beam")
	


func _on_energy_beam_readz() -> void:
	energy_beam.visible = true
	$BeamArea/BeamCollision.disabled = false


func _on_energy_beam_finished(anim_name: StringName) -> void:
	energy_beam.visible = false
	


func _on_boss_attacked(area: Area2D) -> void:
	if !defence_active:
		if area.is_in_group("laser"):
			receive_damage(area, GameManager.laser_damage)
		if area.is_in_group("rocket"):
			receive_damage(area, GameManager.first_boss_rocket_damage)
			activate_defence()
	else:
		area.queue_free()

func receive_damage(projectile: Area2D, damage: int) -> void:
	current_health = current_health - damage
	if current_health <= 0:
		die()
	SignalBus.boss_damaged.emit(damage)
	projectile.queue_free()
	
	
func die() -> void:
	ship.play("death")
	queue_free()
	
func activate_defence() -> void:
	defence_active = true
	shield.visible = true
	shield_timer.start()
	

func _on_shield_end() -> void:
	defence_active = false
	shield.visible = false


func _on_move_timer() -> void:
	is_moved_recently = false
	var right_direction  = Vector2.RIGHT
	var left_direction = Vector2.LEFT
	
	var choosen_direction = randi_range(0, 1)
	if choosen_direction == 0:
		last_move_direction = left_direction
	elif choosen_direction == 1:
		last_move_direction = right_direction
	


func _on_laser_attack_cooldown() -> void:
	laser_attack()


func _on_rocket_timer() -> void:
	speed = 0
	var direction = (player.global_position - global_position).normalized()
	rotation = get_angle_to(player.global_position) + deg_to_rad(-90)
	start_rocket_barage()
