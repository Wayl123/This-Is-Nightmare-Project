extends CharacterBody2D

@onready var hurtbox = %Hurtbox
@onready var moveMarkerLeft = %MoveMarkerLeft
@onready var moveMarkerMiddle = %MoveMarkerMiddle
@onready var moveMarkerRight = %MoveMarkerRight
@onready var moveTimer = %MoveTimer

var ENEMY = preload("res://scene/enemy.tscn")

const MAX_SPEED = 200.0
const MIN_SPEED = 50.0
const ACCEL = 10.0
const TOTAL_HEALTH = 200

var destPosition : Vector2

var speed = 0
var health = TOTAL_HEALTH

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))
	
	destPosition = moveMarkerMiddle.position
	
func _physics_process(delta : float):
	call_deferred("_random_move", delta)
	
	if global_position != destPosition:
		speed = move_toward(speed, (MAX_SPEED if global_position.distance_to(destPosition) > 20 else MIN_SPEED), ACCEL)
		global_position = global_position.move_toward(destPosition, delta * speed)

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
	
func _random_move(delta : float):
	if global_position == destPosition and moveTimer.is_stopped():
		var rng = RandomNumberGenerator.new()
		moveTimer.wait_time = rng.randf_range(0.1, 5.0)
		moveTimer.start()
		await moveTimer.timeout
		
		var randomPosition = rng.randi_range(0, 1) == 0
		match destPosition:
			moveMarkerLeft.position:
				destPosition = moveMarkerMiddle.position if randomPosition else moveMarkerRight.position
			moveMarkerMiddle.position:
				destPosition = moveMarkerLeft.position if randomPosition else moveMarkerRight.position
			moveMarkerRight.position:
				destPosition = moveMarkerLeft.position if randomPosition else moveMarkerMiddle.position
			_:
				destPosition = moveMarkerMiddle.position
