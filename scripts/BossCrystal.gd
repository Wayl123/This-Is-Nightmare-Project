extends Node2D

signal destroyed

@onready var hurtbox = %Hurtbox

const TOTAL_HEALTH = 10

var health = TOTAL_HEALTH

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))

func _got_hit(area : Area2D):
	health -= area.get_damage()
	
	if health <= 0:
		remove_from_group("BossCrystals")
		destroyed.emit()
		queue_free()
