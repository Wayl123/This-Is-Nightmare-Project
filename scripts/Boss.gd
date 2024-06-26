extends CharacterBody2D

signal bossHealthPercent(healthPercent : float)
signal bossDied

@onready var hurtbox = %Hurtbox
@onready var hurtboxCollision = %HurtboxCollisionShape2D
@onready var moveMarkerLeft = %MoveMarkerLeft
@onready var moveMarkerMiddle = %MoveMarkerMiddle
@onready var moveMarkerRight = %MoveMarkerRight
@onready var moveTimer = %MoveTimer
@onready var bobTimer = %BobTimer

@onready var bulletSpawn = get_tree().get_first_node_in_group("BulletSpawn")
@onready var enemySpawn = get_tree().get_first_node_in_group("EnemySpawn")

var ENEMY = preload("res://scene/enemy.tscn")

const MAX_SPEED = 200.0
const MIN_SPEED = 50.0
const ACCEL = 10.0
const TOTAL_HEALTH = 100

var destPosition : Vector2

var phase = 1
var speed = 0
var health = TOTAL_HEALTH

var centerPosition : Vector2
var freq : float

func _ready() -> void:
	hurtbox.connect("area_entered", Callable(self, "_got_hit"))
	enemySpawn.connect("crystals_destroyed", Callable(self, "_set_vuln"))
	
	destPosition = moveMarkerMiddle.position
	
	centerPosition = position
	var rng = RandomNumberGenerator.new()
	freq = rng.randf_range(0.5, 2)
	bobTimer.wait_time = 2 * PI / freq
	bobTimer.start()
	
func _physics_process(delta : float) -> void:
	call_deferred("_random_move", delta)
	
	if not abs(global_position.x - destPosition.x) < 0.001:
		speed = move_toward(speed, (MAX_SPEED if global_position.distance_to(destPosition) > 20 else MIN_SPEED), ACCEL)
		global_position = global_position.move_toward(destPosition, delta * speed)
		
func _process(delta : float) -> void:
	position.y = centerPosition.y + sin(bobTimer.time_left * freq) * 4

func _got_hit(area : Area2D) -> void:
	health -= area.get_damage()
	var healthPercent = float(health) / float(TOTAL_HEALTH)
	var phaseChange : int
	
	bossHealthPercent.emit(healthPercent * 100.0)
	
	if healthPercent <= 0.25:
		phaseChange = 4
	elif healthPercent <= 0.50:
		phaseChange = 3
	elif healthPercent <= 0.75:
		phaseChange = 2
	else:
		phaseChange = 1
		
	#only run phase change once
	if phase != phaseChange:
		phase = phaseChange
		_phase_change(phaseChange)
		
	if health <= 0:
		bossDied.emit()
		
func _phase_change(phase : int) -> void:
	match phase:
		2:
			bulletSpawn.toggle_bullet_spread_timer(true, 1, 4, 8, 100.0, 5.0)
			bulletSpawn.change_big_bullet_spawn_amount(2)
		3:
			bulletSpawn.toggle_bullet_spread_timer(false)
			enemySpawn.change_spawn_timer(2.0)
			enemySpawn.change_spawn_amount(3)
		4:
			bulletSpawn.toggle_bullet_spread_timer(true, 1, 4, 12, 100.0, 3.0)
			bulletSpawn.change_big_bullet_spawn_timer(4.0)
			enemySpawn.change_spawn_timer(1.5)
			enemySpawn.call_deferred("spawn_boss_crystal")
			hurtboxCollision.set_deferred("disabled", true)
			modulate.a = 0.5
		1, _:
			bulletSpawn.toggle_bullet_spread_timer(false)
			bulletSpawn.change_big_bullet_spawn_amount(1)
			bulletSpawn.change_big_bullet_spawn_timer(5.0)
			enemySpawn.change_spawn_timer(3.0)
			enemySpawn.change_spawn_amount(1)
			
func _set_vuln() -> void:
	hurtboxCollision.set_deferred("disabled", false)
	modulate.a = 1
	
func _random_move(delta : float) -> void:
	if abs(global_position.x - destPosition.x) < 0.001 and moveTimer.is_stopped():
		var rng = RandomNumberGenerator.new()
		moveTimer.wait_time = rng.randf_range(1, 7.5)
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
