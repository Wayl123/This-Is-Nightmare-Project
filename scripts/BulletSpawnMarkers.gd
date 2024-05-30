extends Node

@onready var bulletSpawnTopLeft = %BulletSpawnTopLeft
@onready var bulletSpawnBottomLeft = %BulletSpawnBottomLeft
@onready var bulletSpawnTopRight = %BulletSpawnTopRight
@onready var bulletSpawnBottomRight = %BulletSpawnBottomRight
@onready var bigBulletTimer = %BigBulletTimer

var BULLET = preload("res://scene/bullet.tscn")

var order = 0

func _ready():
	bigBulletTimer.connect("timeout", Callable(self, "_spawn_big_bullet"))

func _spawn_big_bullet():
	var bullet = BULLET.instantiate()
	var spawn : Marker2D
	
	match order:
		0:
			spawn = bulletSpawnBottomRight
		1:
			spawn = bulletSpawnTopLeft
		2:
			spawn = bulletSpawnBottomLeft
		3, _:
			spawn = bulletSpawnTopRight
			
	order = (order + 1) % 4
	bullet.add_to_group("EnemyBullets")
	bullet.transform = spawn.transform
	bullet.set_scale(Vector2(4, 4))
	bullet.set("speed", 20.0)
	bullet.set("expireTime", 10.0)
	get_node("/root/BossStage").add_child(bullet)
