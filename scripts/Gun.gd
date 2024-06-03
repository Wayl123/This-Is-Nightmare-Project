extends Node2D

@onready var gunMuzzle = %GunMuzzle
@onready var gunDelay = %GunDelayTimer

@onready var bossStage = get_tree().get_first_node_in_group("BossStage")

var BULLET = preload("res://scene/bullet.tscn")

func shoot():
	gunDelay.start()
	
	var bullet = BULLET.instantiate()
	bullet.add_to_group("PlayerBullets")
	bullet.transform = gunMuzzle.global_transform
	bossStage.add_child(bullet)
