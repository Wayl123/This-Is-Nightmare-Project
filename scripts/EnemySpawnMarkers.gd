extends Node2D

@onready var enemySpawnLeft = %EnemySpawnLeft
@onready var enemySpawnRight = %EnemySpawnRight
@onready var spawnTimer = %SpawnTimer

var ENEMY = preload("res://scene/enemy.tscn")

var alt = true

func _ready():
	spawnTimer.connect("timeout", Callable(self, "_spawn_enemy"))

func _spawn_enemy():
	if get_tree().get_nodes_in_group("Enemies").size() < 4:
		var enemy = ENEMY.instantiate()
		var spawn : Marker2D
		var direction : float
		
		if alt:
			spawn = enemySpawnLeft
			direction = 1.0
		else:
			spawn = enemySpawnRight
			direction = -1.0
			
		alt = not alt
		enemy.position = spawn.position
		enemy.set("direction", direction)
		get_node("/root/BossStage").add_child(enemy)
