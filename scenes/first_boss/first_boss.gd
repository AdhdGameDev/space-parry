extends Area2D

class_name FirstBoss

@export var rocket: PackedScene

@onready var energy_beam_raycast: RayCast2D = $EnergyBeamRaycast
@onready var energy_beam_timer: Timer = $EnergyBeamTimer
@onready var ship: AnimatedSprite2D = $Ship
@onready var engine: AnimatedSprite2D = $Ship/Engine
@onready var energy_beam_animation: AnimationPlayer = $EnergyBeamAnimation
@onready var energy_beam: AnimatedSprite2D = $Ship/EnergyBeam

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


func _ready() -> void:
	engine.play("engine")
	$BeamArea/BeamCollision.disabled = true
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Shield") and not rocket_barage_active:
		start_rocket_barage()
	if Input.is_action_just_pressed("ui_accept") and not energy_beam_active:
		energy_beam_active = true
		energy_beam_attack()
		

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
		end_rocket_barage()

func end_rocket_barage() -> void:
	rocket_barage_active = false
	ship.play("idle")
	
func energy_beam_attack() -> void:
	energy_beam.pla
	energy_beam_timer.start()
	energy_beam_animation.play("energy_beam")
	


func _on_energy_beam_readz() -> void:
	energy_beam.visible = true
	$BeamArea/BeamCollision.disabled = false


func _on_energy_beam_finished(anim_name: StringName) -> void:
	energy_beam.visible = false
	
