extends Node2D

@onready var tileMap = %SpaceTileMap
@onready var platformSwitchTimer = %PlatformSwitchTimer
@onready var player = %Player
@onready var boss = %Boss
@onready var bossHealthBar = %BossHealthBar

func _ready() -> void:
	platformSwitchTimer.connect("timeout", Callable(self, "_flip_platform"))
	player.connect("gameOver", Callable(self, "_reset_game"))
	boss.connect("bossHealthPercent", Callable(self, "_update_health_bar"))

func _flip_platform() -> void:
	tileMap.set_layer_enabled(0, not tileMap.is_layer_enabled(0))
	tileMap.set_layer_enabled(1, not tileMap.is_layer_enabled(1))
	
func _reset_game() -> void:
	pass

func _update_health_bar(healthPercent : float) -> void:
	bossHealthBar.value = healthPercent
