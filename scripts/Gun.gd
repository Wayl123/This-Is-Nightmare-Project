extends Node2D

@onready var gunMuzzle = %GunMuzzle
@onready var gunDelay = %GunDelayTimer

var BULLET = preload("res://scene/bullet.tscn")

func shoot():
	gunDelay.start()
	
	var bullet = BULLET.instantiate()
	bullet.transform = gunMuzzle.global_transform
	get_node("/root/BossStage").add_child(bullet)
