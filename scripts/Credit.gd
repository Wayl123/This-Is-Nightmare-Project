extends Node2D

@onready var returnButton = %Return

@onready var sceneSwitcher = get_tree().get_first_node_in_group("SceneSwitcher")

func _ready() -> void:
	returnButton.connect("pressed", Callable(self, "_return"))

func _return() -> void:
	sceneSwitcher.switch_scene(0, 1)
