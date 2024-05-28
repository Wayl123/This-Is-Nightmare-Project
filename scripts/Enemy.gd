extends CharacterBody2D

@export var direction : float = 1.0:
	set(value):
		direction = value
		
@onready var hurtbox = %Hurtbox

const SPEED = 50.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))

func _physics_process(delta : float):
	if not is_on_floor():
		velocity.y += gravity * delta

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _got_hit(area : Area2D):
	print_debug(area)
	queue_free()
