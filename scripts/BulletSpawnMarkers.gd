extends Node2D

@onready var bulletSpawnLeft1 = %BulletSpawnLeft1
@onready var bulletSpawnLeft2 = %BulletSpawnLeft2
@onready var bulletSpawnLeft3 = %BulletSpawnLeft3
@onready var bulletSpawnLeft4 = %BulletSpawnLeft4
@onready var bulletSpawnLeft5 = %BulletSpawnLeft5
@onready var bulletSpawnRight1 = %BulletSpawnRight1
@onready var bulletSpawnRight2 = %BulletSpawnRight2
@onready var bulletSpawnRight3 = %BulletSpawnRight3
@onready var bulletSpawnRight4 = %BulletSpawnRight4
@onready var bulletSpawnRight5 = %BulletSpawnRight5
@onready var bulletSpawnBoss = %BulletSpawnBoss
@onready var bigBulletTimer = %BigBulletTimer
@onready var bulletSpreadTimer = %BulletSpreadTimer
@onready var bulletSpreadGapTimer = %BulletSpreadGapTimer

var BULLET = preload("res://scene/bullet.tscn")

var spawnList : Array

func _ready():
	bigBulletTimer.connect("timeout", Callable(self, "_spawn_big_bullet"))
	bulletSpreadTimer.connect("timeout", Callable(self, "_spawn_spread_bullet").bind(0.2, 4, 8, 100.0))
	
	spawnList = [bulletSpawnLeft1, bulletSpawnLeft2, bulletSpawnLeft3, bulletSpawnLeft4, bulletSpawnLeft5, bulletSpawnRight1, bulletSpawnRight2, bulletSpawnRight3, bulletSpawnRight4, bulletSpawnRight5]

func _spawn_big_bullet(spawnAmount : int = 1):
	var bullet = BULLET.instantiate()
	var pickSpawn = spawnList.duplicate()
	
	pickSpawn.shuffle()
	pickSpawn.resize(spawnAmount)
	
	for spawn in pickSpawn:
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
