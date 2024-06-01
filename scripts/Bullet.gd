extends Area2D

@onready var timer = %BulletExpirationTimer
@onready var bulletSprite = %AnimatedSprite2D
var speed = 300

func _ready():
	bulletSprite.play("moving")
	connect("area_entered", Callable(self, "_hit_object"))

	timer.timeout.connect(_bullet_expire)

func _physics_process(delta : float):
	position += transform.x * speed * delta

func _hit_object(area : Area2D):
	queue_free()
	
func _bullet_expire():
	queue_free()
