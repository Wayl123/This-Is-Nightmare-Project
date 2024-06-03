extends Node2D

signal crystals_destroyed

@onready var enemySpawnLeft1 = %EnemySpawnLeft1
@onready var enemySpawnLeft2 = %EnemySpawnLeft2
@onready var enemySpawnLeft3 = %EnemySpawnLeft3
@onready var enemySpawnLeft4 = %EnemySpawnLeft4
@onready var enemySpawnRight1 = %EnemySpawnRight1
@onready var enemySpawnRight2 = %EnemySpawnRight2
@onready var enemySpawnRight3 = %EnemySpawnRight3
@onready var enemySpawnRight4 = %EnemySpawnRight4
@onready var crystalSpawn1 = %CrystalSpawn1
@onready var crystalSpawn2 = %CrystalSpawn2
@onready var crystalSpawn3 = %CrystalSpawn3
@onready var crystalSpawn4 = %CrystalSpawn4
@onready var spawnTimer = %SpawnTimer

var ENEMY = preload("res://scene/enemy.tscn")
var BOSSCRYSTAL = preload("res://scene/boss_crystal.tscn")

var spawnList : Array
var crystalSpawnList : Array
var spawnAmount = 1

func _ready() -> void:
	spawnTimer.connect("timeout", Callable(self, "_spawn_enemy"))
	
	spawnList = [enemySpawnLeft1, enemySpawnLeft2, enemySpawnLeft3, enemySpawnLeft4, enemySpawnRight1, enemySpawnRight2, enemySpawnRight3, enemySpawnRight4]
	for spawn in spawnList:
		spawn.connect("spawn_enemy", Callable(self, "_spawn_animation_finished").bind(spawn.position))
		
	crystalSpawnList = [crystalSpawn1, crystalSpawn2, crystalSpawn3, crystalSpawn4]

func _spawn_enemy() -> void:
	var pickSpawn = spawnList.duplicate()
	
	pickSpawn.shuffle()
	pickSpawn.resize(spawnAmount)
		
	for spawn in pickSpawn:
		spawn.play_animation("spawning")

func _spawn_animation_finished(spawnPosition : Vector2) -> void:
	var enemy = ENEMY.instantiate()
	var direction = 1.0
	
	enemy.position = spawnPosition
	direction = 1.0 if enemy.position.x < 0 else -1.0
	enemy.set("direction", direction)
	get_node("/root/BossStage").add_child(enemy)
	
func change_spawn_timer(time : float) -> void:
	spawnTimer.wait_time = time
	
func change_spawn_amount(amount : int) -> void:
	spawnAmount = amount
	
func spawn_boss_crystal() -> void:
	for spawn in crystalSpawnList:
		var bossCrystal = BOSSCRYSTAL.instantiate()
		bossCrystal.add_to_group("BossCrystals")
		bossCrystal.position = spawn.position
		bossCrystal.connect("destroyed", Callable(self, "_all_crystal_destroyed"))
		get_node("/root/BossStage").add_child(bossCrystal)
		
func _all_crystal_destroyed() -> void:
	if get_tree().get_nodes_in_group("BossCrystals").size() <= 0:
		crystals_destroyed.emit()
