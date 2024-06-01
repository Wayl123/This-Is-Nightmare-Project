extends Node2D

@onready var enemySpawnLeft1 = %EnemySpawnLeft1
@onready var enemySpawnLeft2 = %EnemySpawnLeft2
@onready var enemySpawnLeft3 = %EnemySpawnLeft3
@onready var enemySpawnLeft4 = %EnemySpawnLeft4
@onready var enemySpawnRight1 = %EnemySpawnRight1
@onready var enemySpawnRight2 = %EnemySpawnRight2
@onready var enemySpawnRight3 = %EnemySpawnRight3
@onready var enemySpawnRight4 = %EnemySpawnRight4
@onready var spawnTimer = %SpawnTimer

var ENEMY = preload("res://scene/enemy.tscn")

var spawnList : Array

func _ready():
	spawnTimer.connect("timeout", Callable(self, "_spawn_enemy"))
	
	spawnList = [enemySpawnLeft1, enemySpawnLeft2, enemySpawnLeft3, enemySpawnLeft4, enemySpawnRight1, enemySpawnRight2, enemySpawnRight3, enemySpawnRight4]

func _spawn_enemy(spawnAmount : int = 1):
		var enemy = ENEMY.instantiate()
		var pickSpawn = spawnList.duplicate()
		var direction = 1.0
		
		pickSpawn.shuffle()
		pickSpawn.resize(spawnAmount)
			
		for spawn in pickSpawn:
			enemy.position = spawn.position
			direction = 1.0 if enemy.position.x < 0 else -1.0
			enemy.set("direction", direction)
			get_node("/root/BossStage").add_child(enemy)
