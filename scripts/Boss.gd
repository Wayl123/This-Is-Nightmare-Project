extends CharacterBody2D

@onready var hurtbox = %Hurtbox

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))

func _got_hit(area : Area2D):
	print_debug("Hit")
