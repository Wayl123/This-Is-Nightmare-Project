extends Node2D

@onready var bulletSpawnTopLeft = %BulletSpawnTopLeft
@onready var bulletSpawnBottomLeft = %BulletSpawnBottomLeft
@onready var bulletSpawnTopRight = %BulletSpawnTopRight
@onready var bulletSpawnBottomRight = %BulletSpawnBottomRight
@onready var bulletSpawnBoss = %BulletSpawnBoss
@onready var bigBulletTimer = %BigBulletTimer
@onready var bulletSpreadTimer = %BulletSpreadTimer
@onready var bulletSpreadGapTimer = %BulletSpreadGapTimer

var BULLET = preload("res://scene/bullet.tscn")

var order = 0

func _ready():
	bigBulletTimer.connect("timeout", Callable(self, "_spawn_big_bullet"))
	bulletSpreadTimer.connect("timeout", Callable(self, "_spawn_spread_bullet").bind(0.2, 4, 8, 100.0))

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
	bullet.scale = Vector2(4, 4)
	bullet.set("speed", 50.0)
	bullet.set("expireTime", 15.0)
	get_node("/root/BossStage").add_child(bullet)
	
func _spawn_spread_bullet(bulletScale : float = 1.0, spreadTimes : int = 1, spreadAmount : int = 1, bulletSpeed : float = 100.0):
	var rng = RandomNumberGenerator.new()
	bulletSpreadGapTimer.start()
	
	var equalSpread = (2.0 * PI / spreadAmount)
	var randomSpread = rng.randf_range(-(equalSpread / 2.0), (equalSpread / 2.0))
	for n in spreadTimes:
		for m in spreadAmount:
			var bullet = BULLET.instantiate()
			bullet.add_to_group("EnemyBullets")
			bullet.transform = bulletSpawnBoss.global_transform
			bullet.rotation = bullet.rotation + m * equalSpread + n * (equalSpread / 2.0) + randomSpread
			bullet.scale = Vector2(bulletScale, bulletScale)
			bullet.set("speed", bulletSpeed)
			bullet.set("expireTime", 10.0)
			get_node("/root/BossStage").add_child(bullet)
		await bulletSpreadGapTimer.timeout
	bulletSpreadGapTimer.stop()
