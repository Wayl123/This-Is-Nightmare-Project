extends CharacterBody2D

@onready var animation = %AnimatedSprite2D
@onready var hurtbox = %Hurtbox
@onready var invulnTimer = %HitInvulnerabilityTimer
@onready var gun = %Gun
@onready var gunDelay = %GunDelayTimer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var lastStandMode = false
var isInvulerable = false

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))

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
			
		if lastStandMode: 
			animation.play("LSIdle") 
		else: 
			animation.play("Idle")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _process(delta : float):
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right") or Input.is_action_pressed("Up") or Input.is_action_pressed("Down"):
		var vector = Input.get_vector("Left", "Right", "Up", "Down")
		gun.set_rotation(vector.angle())
	
	if Input.is_action_pressed("Shoot") and gunDelay.is_stopped():
		gun.shoot()
		
func _got_hit(area : Area2D):
	if area.is_in_group("Killbox"):
		queue_free()
	else:
		if invulnTimer.is_stopped():
			if lastStandMode:
				print_debug("dead")
				#queue_free()
			else:
				lastStandMode = true
				hurtbox.start_invuln()
		
func _last_stand():
	pass
