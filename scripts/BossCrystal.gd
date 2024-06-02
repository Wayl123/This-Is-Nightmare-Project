extends Node2D

signal destroyed

@onready var hurtbox = %Hurtbox
@onready var bobTimer = %BobTimer

const TOTAL_HEALTH = 10

var health = TOTAL_HEALTH

var centerPosition : Vector2
var freq : float

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))
	
	centerPosition = position
	var rng = RandomNumberGenerator.new()
	freq = rng.randf_range(0.5, 2)
	bobTimer.wait_time = 2 * PI / freq
	bobTimer.start()
	
func _process(delta : float):
	position.y = centerPosition.y + sin(bobTimer.time_left * freq) * 3

func _got_hit(area : Area2D):
	health -= area.get_damage()
	
	if health <= 0:
		remove_from_group("BossCrystals")
		destroyed.emit()
		queue_free()
