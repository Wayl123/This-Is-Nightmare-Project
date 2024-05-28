extends CharacterBody2D

@onready var hurtbox = %Hurtbox
@onready var enemySpawnLeft = %EnemySpawnLeft
@onready var enemySpawnRight = %EnemySpawnRight

var ENEMY = preload("res://scene/enemy.tscn")

const TOTALHEALTH = 1000.0

var health = 1000

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))

func _got_hit(area : Area2D):
	health -= 1
	var healthPercent = health / TOTALHEALTH * 100
	
	call_deferred("_spawn_enemy", -1.0)
	
	print_debug(healthPercent)
	
func _spawn_enemy(direction : float):
	var enemy = ENEMY.instantiate()
	enemy.transform = enemySpawnRight.global_transform
	enemy.set("direction", direction)
	get_parent().add_child(enemy)
