extends CharacterBody2D

@onready var hurtbox = %Hurtbox

var ENEMY = preload("res://scene/enemy.tscn")

const TOTAL_HEALTH = 1000

var health = 1000

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))

func _got_hit(area : Area2D):
	health -= area.get_damage()
	var healthPercent = float(health) / float(TOTAL_HEALTH)
	
	if healthPercent <= 25: #Phase 4
		pass
	elif healthPercent <= 50: #Phase 3
		pass
	elif healthPercent <= 75: #Phase 2
		pass
	else: #Phase 1
		pass
	
	print_debug(healthPercent)
