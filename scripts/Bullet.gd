extends Area2D

@export var speed : float = 300.0:
	set(value):
		speed = value
@export var expireTime : float = 5.0:
	set(value):
		expireTime = value

@onready var timer = %BulletExpirationTimer
@onready var bulletSprite = %AnimatedSprite2D
@onready var bulletCollision = %CollisionShape2D
@onready var bigBulletCollision = %CollisionPolygon2D

var damage = 1

func _ready() -> void:
	connect("area_entered", Callable(self, "_hit_object"))

	_set_bullet_property()
	timer.wait_time = expireTime
	timer.start()
	timer.timeout.connect(_bullet_expire)

func _physics_process(delta : float) -> void:
	position += (transform.x / scale) * speed * delta

func _set_bullet_property() -> void:
	if is_in_group("PlayerBullets"):
		bulletSprite.play("playerBulletMoving")
		set_collision_layer_value(3, true)
		set_collision_mask_value(4, true)
	elif is_in_group("EnemyBullets"):
		bulletSprite.play("enemyBulletMoving")
		set_collision_layer_value(5, true)
		set_collision_mask_value(2, true)
	elif is_in_group("EnemyBigBullets"):
		bulletSprite.play("enemyBigBulletMoving")
		set_collision_layer_value(5, true)
		set_collision_mask_value(2, true)
		bulletCollision.set_deferred("disabled", true)
		bigBulletCollision.set_deferred("disabled", false)

func _hit_object(area : Area2D) -> void:
	if is_in_group("PlayerBullets"):
		bulletCollision.set_deferred("disabled", true)
		speed = 0
		bulletSprite.play("playerBulletImpact")
		await bulletSprite.animation_finished
		queue_free()
	
func _bullet_expire() -> void:
	queue_free()
	
func get_damage() -> float:
	return damage
