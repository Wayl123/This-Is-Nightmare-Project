extends Node2D

@onready var tileMap = %SpaceTileMap
@onready var platformSwitchTimer = %PlatformSwitchTimer
@onready var boss = %Boss
@onready var bossHealthBar = %BossHealthBar

func _ready():
	platformSwitchTimer.connect("timeout", Callable(self, "_flip_platform"))
	boss.connect("bossHealthPercent", Callable(self, "_update_health_bar"))

func _flip_platform():
	tileMap.set_layer_enabled(0, not tileMap.is_layer_enabled(0))
	tileMap.set_layer_enabled(1, not tileMap.is_layer_enabled(1))

func _update_health_bar(healthPercent : float):
	bossHealthBar.value = healthPercent
