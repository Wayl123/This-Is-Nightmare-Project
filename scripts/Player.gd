extends CharacterBody2D

@onready var gun = %Gun
@onready var gunMuzzle = %GunMuzzle
@onready var gunDelay = %GunDelay

var BULLET = preload("res://scene/bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta : float):
	if not is_on_floor():
		velocity.y += gravity * delta

	if not Input.is_action_pressed("Stop"):
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _process(delta : float):
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right") or Input.is_action_pressed("Up") or Input.is_action_pressed("Down"):
		var vector = Input.get_vector("Left", "Right", "Up", "Down")
		var roundAngle = round(vector.angle()/(PI/2.0))*(PI/2.0)
		gun.set_rotation(roundAngle)
	
	if Input.is_action_pressed("Shoot") and gunDelay.is_stopped():
		_shoot()
		gunDelay.start()
		
func _shoot():
	var bullet = BULLET.instantiate()
	bullet.transform = gunMuzzle.global_transform
	get_parent().add_child(bullet)
