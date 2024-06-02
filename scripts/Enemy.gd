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

	velocity.x = direction * SPEED
	
	if is_on_wall():
		_despawn()

	move_and_slide()

func _got_hit(area : Area2D):
	if area.is_in_group("PlayerBullets"):
		get_tree().get_first_node_in_group("Player").enemy_killed()
	queue_free()

func _despawn():
	queue_free()
