extends CharacterBody2D

@onready var animation = %AnimatedSprite2D
@onready var hurtbox = %Hurtbox
@onready var invulnTimer = %HitInvulnerabilityTimer
@onready var gun = %Gun
@onready var gunDelay = %GunDelayTimer

const SPEED = 150.0
const JUMP_VELOCITY = -500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var lastStandMode = false
var isInvulerable = false

var idleAnimation = "Idle"
var shootSideAnimation = "ShootSide"
var shootDownAnimation = "ShootDown"
var shootUpAnimation = "ShootUp"

var facingAngle

func _ready():
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))

func _physics_process(delta : float):
	if not is_on_floor():
		velocity.y += gravity * delta

	if not Input.is_action_pressed("Stop"):
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("Left", "Right")
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
		
	if not Input.is_action_pressed("Shoot") and not Input.is_action_pressed("Stop"):
		animation.play(idleAnimation)
	
	move_and_slide()
	
func _process(delta : float):
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right") or Input.is_action_pressed("Up") or Input.is_action_pressed("Down"):
		var vector = Input.get_vector("Left", "Right", "Up", "Down")
		facingAngle = round(vector.angle() / (PI / 2.0)) * (PI / 2.0)
		gun.rotation = facingAngle
	
	if (Input.is_action_pressed("Shoot") or Input.is_action_pressed("Stop")) and gunDelay.is_stopped():
		if abs(facingAngle - 0) < 0.000001:
			animation.flip_h = false
			animation.play(shootSideAnimation)
		elif abs(facingAngle - PI) < 0.000001:
			animation.flip_h = true
			animation.play(shootSideAnimation)
		elif abs(facingAngle - (PI / 2.0)) < 0.000001:
			animation.play(shootDownAnimation)
		elif abs(facingAngle + (PI / 2.0)) < 0.000001:
			animation.play(shootUpAnimation)
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
				_last_stand(true)
				hurtbox.start_invuln()
		
func _last_stand(isLS : bool):
	lastStandMode = isLS
	idleAnimation = "IdleLS" if isLS else "Idle"
	shootSideAnimation = "ShootSideLS" if isLS else "ShootSide"
	shootDownAnimation = "ShootDownLS" if isLS else "ShootDown"
	shootUpAnimation = "ShootUpLS" if isLS else "ShootUp"
	
func enemy_killed():
	if lastStandMode:
		_last_stand(false)
