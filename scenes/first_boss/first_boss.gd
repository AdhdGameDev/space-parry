extends Area2D

class_name FirstBoss

@export var rocket: PackedScene

@onready var ship: AnimatedSprite2D = $Ship
@onready var engine: AnimatedSprite2D = $Ship/Engine
@onready var energy_beam_animation: AnimationPlayer = $EnergyBeamAnimation
@onready var energy_beam: AnimatedSprite2D = $Ship/EnergyBeam
@onready var shield: AnimatedSprite2D = $Ship/Shield
@onready var rocket_start_sound: AudioStreamPlayer2D = $RocketStartSound

@onready var laser_barage_timer_end: Timer = $LaserBarageTimerEnd
@onready var energy_beam_timer: Timer = $EnergyBeamTimer
@onready var laser_attack_timer: Timer = $LaserAttackTimer
@onready var start_action_timer: Timer = $StartActionTimer

var state_machine: BossStateMachine

@onready var player: Area2D
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
var can_fire_regular_laser: bool = true
var last_move_direction: Vector2 = Vector2.LEFT
var speed: float  = GameManager.first_boss_speed


func _ready() -> void:
	state_machine = BossStateMachine.new()
	state_machine.set_boss(self)
	add_child(state_machine)
	state_machine.change_state(GameManager.STATE_IDLE)
	
	current_health = GameManager.first_boss_health
	engine.play("engine")
	$BeamArea/BeamCollision.disabled = true
	player = get_tree().get_nodes_in_group("player")[0]
	
func _process(delta: float) -> void:
	state_machine._process(delta)
		
	
func move(delta: float) -> void:
	var screen_width = 1300
	position += speed * last_move_direction * delta
	if global_position.x < 0:
		position.x = 0
		last_move_direction = Vector2.RIGHT
	elif global_position.x > screen_width:
		position.x = screen_width
		last_move_direction = Vector2.LEFT
	SignalBus.boss_moved.emit(position)
	
func laser_attack() -> void:
	laser_attack_timer.autostart = true
	laser_attack_timer.start()
	laser_barage_timer_end.start()
	
func start_rocket_barage() -> void:
	ship.play("fire")

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
	SignalBus.boss_beam_finished.emit()
	

func _on_boss_attacked(area: Area2D) -> void:
	if !defence_active:
		if area is BigBossLaser and area.reflected:
			area.explode()
			receive_damage(area, GameManager.first_boss_big_laser)
		if area.is_in_group("laser"):
			receive_damage(area, GameManager.laser_damage)
	else:
		$ShieldSound.play()
		area.queue_free()

func receive_damage(projectile: Area2D, damage: int) -> void:
	current_health = current_health - damage
	if current_health <= 0:
		die()
	SignalBus.boss_damaged.emit(damage)
	projectile.die()
	
	
func die() -> void:
	ship.play("death")
	queue_free()
	
