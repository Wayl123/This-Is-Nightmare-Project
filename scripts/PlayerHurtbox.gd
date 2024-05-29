extends Area2D

@onready var hurtboxCollision = %HurtboxCollisionShape2D
@onready var invulnTimer = %HitInvulnerabilityTimer
@onready var blinkTimer = %BlinkTimer

func _ready():
	invulnTimer.connect("timeout", Callable(self, "_stop_blink"))
	blinkTimer.connect("timeout", Callable(self, "_blink_effect"))

func start_invuln():
	hurtboxCollision.set_deferred("disabled", true)
	invulnTimer.start()
	blinkTimer.start()
	await invulnTimer.timeout
	hurtboxCollision.set_deferred("disabled", false)
	
func _blink_effect():
	var object = get_parent()
	
	object.set_visible(not object.is_visible())
	
func _stop_blink():
	blinkTimer.stop()
	
	get_parent().set_visible(true)
	
