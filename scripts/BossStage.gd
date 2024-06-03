extends Node2D

@onready var tileMap = %SpaceTileMap
@onready var platformSwitchTimer = %PlatformSwitchTimer
@onready var player = %Player
@onready var boss = %Boss
@onready var bossHealthBar = %BossHealthBar

@onready var sceneSwitcher = get_tree().get_first_node_in_group("SceneSwitcher")

func _ready() -> void:
	platformSwitchTimer.connect("timeout", Callable(self, "_flip_platform"))
	player.connect("gameOver", Callable(self, "_reset_game"))
	boss.connect("bossHealthPercent", Callable(self, "_update_health_bar"))
	boss.connect("bossDied", Callable(self, "_load_credit"))

func _flip_platform() -> void:
	tileMap.set_layer_enabled(0, not tileMap.is_layer_enabled(0))
	tileMap.set_layer_enabled(1, not tileMap.is_layer_enabled(1))
	
func _reset_game() -> void:
	sceneSwitcher.switch_scene(1)

func _update_health_bar(healthPercent : float) -> void:
	bossHealthBar.value = healthPercent
	
func _load_credit():
	sceneSwitcher.switch_scene(2, 0)
