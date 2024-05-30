extends Area2D

@export var speed : float = 750.0:
	set(value):
		speed = value
@export var expireTime : float = 5.0:
	set(value):
		expireTime = value

@onready var timer = %BulletExpirationTimer

var damage = 1

func _ready():
	connect("area_entered", Callable(self, "_hit_object"))

	_set_bullet_collision()
	timer.set_wait_time(expireTime)
	timer.start()
	timer.timeout.connect(_bullet_expire)

func _physics_process(delta : float):
	position += transform.x * speed * delta

func _set_bullet_collision():
	if is_in_group("PlayerBullets"):
		set_collision_layer_value(3, true)
		set_collision_mask_value(4, true)
	elif is_in_group("EnemyBullets"):
		set_collision_layer_value(5, true)
		set_collision_mask_value(2, true)

func _hit_object(area : Area2D):
	queue_free()
	
func _bullet_expire():
	print_debug("expired")
	queue_free()
	
func get_damage():
	return damage
