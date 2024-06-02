extends Marker2D

signal spawn_enemy

@onready var sprite = %AnimatedSprite2D

func _ready():
	sprite.connect("animation_finished", Callable(self, "_idle"))

func play_animation(animation : String):
	sprite.play(animation)
	
func _idle():
	spawn_enemy.emit()
	sprite.play("idle")
