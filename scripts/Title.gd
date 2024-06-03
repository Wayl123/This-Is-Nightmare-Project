extends Node2D

@onready var tutorialButton = %Tutorial
@onready var creditButton = %Credit

@onready var sceneSwitcher = get_tree().get_first_node_in_group("SceneSwitcher")

func _ready():
	tutorialButton.connect("pressed", Callable(self, "_tutorial"))
	creditButton.connect("pressed", Callable(self, "_credit"))

func _tutorial():
	sceneSwitcher.switch_scene(1, 1)
	
func _credit():
	sceneSwitcher.switch_scene(2)
