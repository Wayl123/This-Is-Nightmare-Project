extends Marker2D

signal spawn_enemy

@onready var sprite = %AnimatedSprite2D
@onready var bobTimer = %BobTimer

var centerPosition : Vector2
var freq : float

func _ready() -> void:
	sprite.connect("animation_finished", Callable(self, "_idle"))
	
	centerPosition = position
	var rng = RandomNumberGenerator.new()
	freq = rng.randf_range(0.5, 2)
	bobTimer.wait_time = 2 * PI / freq
	bobTimer.start()
	
func _process(delta : float) -> void:
	position.y = centerPosition.y + sin(bobTimer.time_left * freq) * 2

func play_animation(animation : String) -> void:
	sprite.play(animation)
	
func _idle() -> void:
	spawn_enemy.emit()
	sprite.play("idle")
