extends Node


var level_one = preload("res://scenes/level_one/level_one.tscn")
var level_one_boss = preload("res://scenes/first_boss/first_boss_arena.tscn")

enum GameMode {
	LEVEL_1 = 0,
	BOSS_LEVEL_1 = 1
}

const LEVEL_ONE_NEEDED_SCORE = 300

var player_max_health = 4
var maximum_enemies = 5

var laser_damage: int = 10
var first_boss_health: int = 1000
var first_boss_speed: float = 150
var first_boss_big_laser: int = 100

const BASIC_ENEMY_SCORE: int = 10
const BASIC_ENEMY_DAMAGE: int = 10

const ELITE_ENEMY_SCORE: int = 30
const ELITE_ENEMY_DAMAGE: int = 30
const ELITE_ENEMY_HEALTH: int = 30
const BOMB_ENEMY_SCORE: int = 30


var game_mode: int = GameMode.LEVEL_1


func load_first_level_scene() -> void:
	get_tree().change_scene_to_packed(level_one)
	
func load_first_level_boss_scene() -> void:
	get_tree().change_scene_to_packed(level_one_boss)
