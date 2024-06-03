extends Node

@onready var animationPlayer = %AnimationPlayer
@onready var musicPlayer = %AudioStreamPlayer

var titleMusic = preload("res://music/Rob0ne - Chiptune Madness - Night Drive .mp3")
var bossMusic = preload("res://music/Rob0ne - Chiptune Madness - Tokyo Invasion.mp3")

var currentScene : Node2D
var newScene : Node2D

var musicList : Array

func _ready() -> void:
	musicPlayer.connect("finished", Callable(self, "_loop_music"))
	#_set_current_scene()
	
	musicList = [titleMusic, bossMusic]
	
func _loop_music() -> void:
	musicPlayer.play()

func _set_current_scene() -> void:
	if currentScene:
		currentScene.queue_free()
	currentScene = newScene
	add_child(newScene)

func switch_music(index : int) -> void:
	musicPlayer.stream = musicList[index]
	musicPlayer.play()
	

