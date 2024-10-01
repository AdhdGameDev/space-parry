extends CharacterBody2D

class_name Player

@export var enemy: PackedScene
@export var eliteEnemy: PackedScene
@export var laser: PackedScene
@export var shield_explosion: PackedScene
@export var ghost_dash_node: PackedScene
@onready var deflect_area: Area2D = $DeflectArea

@onready var deflect_timer_buffer: Timer = $DeflectTimerBuffer
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var shield_timer: Timer = $ShieldTimer
@onready var shield_cooldown_timer: Timer = $ShieldCooldownTimer

@onready var new_design_ship: AnimatedSprite2D = $NewDesignShip
@onready var engine_effect: AnimatedSprite2D = $NewDesignShip/EngineEffect
@onready var laser_gun: AnimatedSprite2D = $NewDesignShip/LaserGun
@onready var deflect_shield: AnimatedSprite2D = $NewDesignShip/DeflectShield
@onready var next_level_timer: Timer = $NextLevelTimer
@onready var dash_ghosting_timer: Timer = $DashGhostingTimer
@onready var laser_sound: AudioStreamPlayer = $LaserSound

@onready var shield: Sprite2D = $Shield
@onready var ship_collision: CollisionShape2D = $ShipCollision

@export var health: int = GameManager.player_max_health
@export var enemy_max_count: int = GameManager.maximum_enemies
var current_enemy_count: int = 0

@export var attack_component: PlayerAttackComponent

var player_speed: float = 250.0

var shield_active: bool = false
var shield_cooldown_passed: bool = true
var can_laser: bool = true

var acceleration: float = 700.0
var deacceleration: float = 300.0
var max_speed: float = 300.0
var friction: float = 0.93

# This is the direction the ship faces for shooting or deflecting
var aim_direction: Vector2 = Vector2.UP  # Default direction the ship faces

var level_complete: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deflect_shield.visible = false
	shield.visible = false
	SignalBus.enemy_destroyed.connect(enemy_destroyed)
	SignalBus.player_collision_hit.connect(on_player_collision_hit)
	SignalBus.rocked_exploded.connect(_on_rocket_exploded)
	SignalBus.on_basic_dialog_yes_pressed.connect(_on_level_complete)
	enemy_spawn_timer.start()
	
func add_ghosting_dash_effect():
	var ghost_dash = ghost_dash_node.instantiate()
	ghost_dash.set_property(global_position, new_design_ship.scale, rotation)
	get_parent().add_child(ghost_dash)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if level_complete:
		move_to_the_next_level(delta)
	else:
		deflect_area.rotation = new_design_ship.rotation
		if Input.is_action_just_pressed("Deflect"):
			deflect_shield.visible = true
			deflect_shield.play("deflect")
			deflect_timer_buffer.start()
			try_to_deflect()
		if Input.is_action_just_pressed("LaserFirePlayer"):
			attack_component.fire_laser()
		if Input.is_action_just_pressed("Shield"):
			activate_shield()
		SignalBus.player_moved.emit(global_position)
		#if GameManager.game_mode == GameManager.GameMode.BOSS_LEVEL_1:
			#move(delta)
			
func _physics_process(delta: float) -> void:
	# Get input for absolute movement based on screen directions
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_direction != Vector2.ZERO:
		input_direction = input_direction.normalized()  # Normalize to prevent fast diagonal movement
		velocity = velocity.move_toward(input_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity * friction  # Gradually reduce the velocity for smooth stopping

	move_and_slide()
	update_aim_direction()

	if aim_direction != Vector2.ZERO:
		rotation = aim_direction.angle() + deg_to_rad(90)
	
	if Input.is_action_just_pressed("Dash"):
		dash()


func update_aim_direction() -> void:
	var mouse_position = get_global_mouse_position()
	aim_direction = (mouse_position - global_position).normalized()
	
func dash() -> void:
	dash_ghosting_timer.start()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + velocity * 1.5, 0.50)
	
	await tween.finished
	dash_ghosting_timer.stop()
	
func move_to_the_next_level(delta: float) -> void:
	var new_direction = Vector2.UP
	var gain_velocity = 50.0
	player_speed += gain_velocity
	position += new_direction * player_speed * delta

func enemy_destroyed(points: int) -> void:
	current_enemy_count = current_enemy_count - 1
	
func activate_shield() -> void:
	if shield_cooldown_passed:
		shield_cooldown_passed = !shield_cooldown_passed
		shield_cooldown_timer.start()
		shield_active = !shield_active
		shield.visible = !shield.visible
		ship_collision.scale = ship_collision.scale * 2
		shield_timer.start()
	
func try_to_deflect() -> void:
	if deflect_timer_buffer.time_left > 0:
		for projectile in deflect_area.get_overlapping_areas():
			if projectile is BasicProjectile:
				if projectile.can_be_reflected:
					$DeflectSound.play()
					projectile.deflect()
		

func _on_enemy_spawn_timer_timeout() -> void:
	if enemy_max_count > current_enemy_count:
		EnemyFactory.spawn_enemy(EnemyFactory.EnemyType.REGULAR_ENEMY)
		current_enemy_count = current_enemy_count + 1

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("beam") and !shield_active:
		SignalBus.player_death.emit()
	if !area.is_in_group("laser"):
		if !shield_active:
			print(area)
			health = health - 1
			SignalBus.player_damaged.emit(1)
			if health == 0:
				SignalBus.player_death.emit()
			var next_frame = new_design_ship.frame + 1
			new_design_ship.set_frame_and_progress(next_frame, 1)
			
func on_player_collision_hit(global_pos: Vector2) -> void:
	var shield_exp = shield_explosion.instantiate()
	shield_exp.global_position = to_local(global_pos)
	shield_exp.play("explosion")
	add_child(shield_exp)
	
func _on_shield_end() -> void:
	shield_active = false
	shield.visible = !shield.visible
	ship_collision.scale = ship_collision.scale / 2


func _on_shield_cooldown_passed() -> void:
	shield_cooldown_passed = !shield_cooldown_passed
	

func _on_deflect_end() -> void:
	deflect_shield.visible = false
	
func _on_rocket_exploded(position: Vector2) -> void:
	if global_position.distance_to(position) < 75:
		SignalBus.player_death.emit()


func _on_level_complete() -> void:
	next_level_timer.start()
	level_complete = true


func _on_next_level_timer_timeout() -> void:
	GameManager.load_first_level_boss_scene()


func _on_dash_ghosting_timer_timeout() -> void:
	add_ghosting_dash_effect()
