extends Area2D

@onready var timer = %BulletExpirationTimer

var speed = 750

func _ready():
	connect("body_entered", Callable(self, "_hit_object"))

	timer.timeout.connect(_bullet_expire)

func _physics_process(delta : float):
	position += transform.x * speed * delta

func _hit_object(body : Node2D):
	queue_free()
	
func _bullet_expire():
	queue_free()