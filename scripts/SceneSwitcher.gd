extends Node

@onready var animationPlayer = %AnimationPlayer
@onready var musicPlayer = %AudioStreamPlayer

var bossScene = preload("res://scene/boss_stage.tscn")
var creditScene = preload("res://scene/credit.tscn")

var titleMusic = preload("res://music/Rob0ne - Chiptune Madness - Night Drive .mp3")
var bossMusic = preload("res://music/Rob0ne - Chiptune Madness - Tokyo Invasion.mp3")

var currentScene : Node2D
var newScene : Node2D

var sceneList : Array
var musicList : Array

func _ready() -> void:
	musicPlayer.connect("finished", Callable(self, "_loop_music"))
	
	sceneList = [bossScene, creditScene]
	musicList = [titleMusic, bossMusic]
	
	newScene = bossScene.instantiate()
	_switch_music(1)
	_set_current_scene()
	
func _loop_music() -> void:
	musicPlayer.play()

func _set_current_scene() -> void:
	if currentScene:
		currentScene.queue_free()
		await currentScene.tree_exited
	currentScene = newScene
	add_child(newScene)

func _switch_music(musicIndex : int) -> void:
	if musicIndex != -1:
		musicPlayer.stop()
		musicPlayer.stream = musicList[musicIndex]
		musicPlayer.play()
	
func switch_scene(sceneIndex : int, musicIndex : int = -1) -> void:
	if not animationPlayer.is_playing():
		newScene = sceneList[sceneIndex].instantiate()
		_switch_music(musicIndex)
		animationPlayer.play("transition_fade")
	

