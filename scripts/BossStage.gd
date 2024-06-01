extends Node2D

@onready var tileMap = %SpaceTileMap
@onready var platformSwitchTimer = %PlatformSwitchTimer

func _ready():
	platformSwitchTimer.connect("timeout", Callable(self, "_flip_platform"))
	
func _flip_platform():
	tileMap.set_layer_enabled(0, not tileMap.is_layer_enabled(0))
	tileMap.set_layer_enabled(1, not tileMap.is_layer_enabled(1))
