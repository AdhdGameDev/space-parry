extends Node


enum GameMode {
	LEVEL_1 = 0,
	BOSS_LEVEL_1 = 1
}

var laser_damage: int = 10
var first_boss_health: int = 1000
var first_boss_speed: float = 150
var first_boss_big_laser: int = 100


var game_mode: int = GameMode.LEVEL_1
