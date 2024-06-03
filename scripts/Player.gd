extends CharacterBody2D

signal gameOver

@onready var animation = %AnimatedSprite2D
@onready var collision = %CollisionShape2D
@onready var dropTimer = %DropThroughTimer
@onready var lastStandTimer = %LastStandTimer
@onready var hurtbox = %Hurtbox
@onready var invulnTimer = %HitInvulnerabilityTimer
@onready var gun = %Gun
@onready var gunDelay = %GunDelayTimer
@onready var lastStandIndicator = %LastStandIndicator

const SPEED = 150.0
const JUMP_VELOCITY = -500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var lastStandMode = false
var isInvulerable = false

var idleAnimation = "Idle"
var shootSideAnimation = "ShootSide"
var shootDownAnimation = "ShootDown"
var shootUpAnimation = "ShootUp"

var facingAngle = 0.0

func _ready() -> void:
	dropTimer.connect("timeout", Callable(self, "_stop_drop"))
	lastStandTimer.connect("timeout", Callable(self, "_last_stand_expire"))
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))

func _physics_process(delta : float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("Down") and is_on_floor():
		set_collision_mask_value(7, false)
		dropTimer.start()

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
	
func _process(delta : float) -> void:
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right") or Input.is_action_pressed("Up") or Input.is_action_pressed("Down"):
		var vector = Input.get_vector("Left", "Right", "Up", "Down")
		facingAngle = round(vector.angle() / (PI / 2.0)) * (PI / 2.0)
		gun.rotation = facingAngle
		
	if abs(facingAngle - 0) < 0.000001:
		animation.flip_h = false
	elif abs(facingAngle - PI) < 0.000001:
		animation.flip_h = true
	
	if (Input.is_action_pressed("Shoot") or Input.is_action_pressed("Stop")):
		if abs(facingAngle - 0) < 0.000001 or abs(facingAngle - PI) < 0.000001:
			animation.play(shootSideAnimation)
		elif abs(facingAngle - (PI / 2.0)) < 0.000001:
			animation.play(shootDownAnimation)
		elif abs(facingAngle + (PI / 2.0)) < 0.000001:
			animation.play(shootUpAnimation)
			
		if gunDelay.is_stopped():
			gun.shoot()
		
func _stop_drop() -> void:
	set_collision_mask_value(7, true)
		
func _got_hit(area : Area2D) -> void:
	if area.is_in_group("Killbox"):
		queue_free()
	else:
		if invulnTimer.is_stopped():
			if lastStandMode:
				gameOver.emit()
			else:
				_last_stand(true)
				hurtbox.start_invuln()
		
func _last_stand(isLS : bool) -> void:
	lastStandMode = isLS
	if isLS:
		lastStandTimer.start()
		lastStandIndicator.visible = true
		lastStandIndicator.play("LastStand")
	else:
		lastStandTimer.stop()
		lastStandIndicator.visible = false
		lastStandIndicator.stop()
		lastStandIndicator.frame = 0
	idleAnimation = "IdleLS" if isLS else "Idle"
	shootSideAnimation = "ShootSideLS" if isLS else "ShootSide"
	shootDownAnimation = "ShootDownLS" if isLS else "ShootDown"
	shootUpAnimation = "ShootUpLS" if isLS else "ShootUp"
	
func enemy_killed() -> void:
	if lastStandMode:
		_last_stand(false)

func _last_stand_expire() -> void:
	gameOver.emit()
