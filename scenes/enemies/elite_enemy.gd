extends BasicEnemy

var boosted: bool = false
var can_use_boost: bool = true
@onready var boosted_timer: Timer = $BoostedTimer
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var boosted_cooldown_timer: Timer = $BoostedCooldownTimer

@export var energy_sphere: PackedScene
var health: int = GameManager.ELITE_ENEMY_HEALTH

func _on_attacked_by_player(area: Area2D) -> void:
	if !area.is_in_group("enemy") and !area.is_in_group("elite_projectile") and !boosted:
		var damage = get_damage(area)
		health = health - damage
		if health <= 0:
			die(GameManager.ELITE_ENEMY_SCORE)
		elif can_use_boost:
			boost()
			start_attack()
			attack_cooldown_timer.start()
	elif area.is_in_group("enemy"):
		direction = direction * -1
		rotation = current_angle + deg_to_rad(90)
		
func boost() -> void:
	attack_cooldown_timer.wait_time = attack_cooldown_timer.wait_time / 3
	can_use_boost = !can_use_boost
	boosted_cooldown_timer.start()
	boosted_timer.start()
	boosted = !boosted
	rotation_speed = rotation_speed * 2

func get_damage(area: Area2D) -> int:
	if area.is_in_group("elite_projectile"):
		var elite_projectile: EliteProjectile = area
		if elite_projectile.reflected:
			return GameManager.ELITE_ENEMY_DAMAGE
		else:
			return 0
	elif area.is_in_group("projectile") or area.is_in_group("laser"):
		return GameManager.BASIC_ENEMY_DAMAGE
	else:
		return 0	
		
		
func _on_boost_end() -> void:
	boosted = !boosted
	rotation_speed = rotation_speed / 2
	attack_cooldown_timer.wait_time = attack_cooldown_timer.wait_time * 3
	
func start_attack() -> void:
	spawn_projectile()


func _on_attack_cooldown() -> void:
	spawn_projectile()


func spawn_projectile() -> void:
	ProjectileFactory.spawn_projectile(ProjectileFactory.ProjectileType.ELITE_PROJECTILE, center_position, global_position)

func _on_boosted_cooldown_up() -> void:
	can_use_boost = !can_use_boost
