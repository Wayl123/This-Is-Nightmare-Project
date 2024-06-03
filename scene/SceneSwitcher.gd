extends Node

var currentScene : Node2D
var newScene : Node2D

func _ready() -> void:
	_set_current_scene()

func _set_current_scene() -> void:
	if currentScene:
		currentScene.queue_free()
	currentScene = newScene
	add_child(newScene)
