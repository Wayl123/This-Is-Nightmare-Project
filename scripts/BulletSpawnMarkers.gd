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
@onready var bigBulletTimer = %BigBulletTimer
@onready var bulletSpreadTimer = %BulletSpreadTimer
@onready var bulletSpreadGapTimer = %BulletSpreadGapTimer

@onready var boss = get_tree().get_first_node_in_group("Boss")

var BULLET = preload("res://scene/bullet.tscn")

var spawnList : Array
var bigSpawnAmount = 1

func _ready():
	bigBulletTimer.connect("timeout", Callable(self, "_spawn_big_bullet"))
	
	spawnList = [bulletSpawnLeft1, bulletSpawnLeft2, bulletSpawnLeft3, bulletSpawnLeft4, bulletSpawnLeft5, bulletSpawnRight1, bulletSpawnRight2, bulletSpawnRight3, bulletSpawnRight4, bulletSpawnRight5]

func _spawn_big_bullet():
	var bullet = BULLET.instantiate()
	var pickSpawn = spawnList.duplicate()
	
	pickSpawn.shuffle()
	pickSpawn.resize(bigSpawnAmount)
	
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
			bullet.transform = boss.global_transform
			bullet.rotation = bullet.rotation + m * equalSpread + n * (equalSpread / 2.0) + randomSpread
			bullet.scale = Vector2(bulletScale, bulletScale)
			bullet.set("speed", bulletSpeed)
			bullet.set("expireTime", 10.0)
			get_node("/root/BossStage").add_child(bullet)
		await bulletSpreadGapTimer.timeout
	bulletSpreadGapTimer.stop()
	
func change_big_bullet_spawn_timer(time : float):
	bigBulletTimer.wait_time = time

func change_big_bullet_spawn_amount(amount : int):
	bigSpawnAmount = amount
	
func toggle_bullet_spread_timer(start : bool = false, bulletScale : float = 1.0, spreadTimes : int = 1, spreadAmount : int = 1, bulletSpeed : float = 100.0, shotTime : float = 5.0):
	if start:
		bulletSpreadTimer.connect("timeout", Callable(self, "_spawn_spread_bullet").bind(bulletScale, spreadTimes, spreadAmount, bulletSpeed))
		bulletSpreadTimer.wait_time = shotTime
		bulletSpreadTimer.start()
	else:
		bulletSpreadTimer.stop()
