extends Area2D

@onready var hurtboxCollision = %HurtboxCollisionShape2D
@onready var invulnTimer = %HitInvulnerabilityTimer
@onready var blinkTimer = %BlinkTimer

func _ready() -> void:
	invulnTimer.connect("timeout", Callable(self, "_stop_blink"))
	blinkTimer.connect("timeout", Callable(self, "_blink_effect"))

func start_invuln() -> void:
	hurtboxCollision.set_deferred("disabled", true)
	invulnTimer.start()
	blinkTimer.start()
	await invulnTimer.timeout
	hurtboxCollision.set_deferred("disabled", false)
	
func _blink_effect() -> void:
	var object = get_parent()
	
	object.visible = not object.visible
	
func _stop_blink() -> void:
	blinkTimer.stop()
	
	get_parent().visible = true
	
