class_name PlayerCamera extends Camera2D

var target_position: Vector2
var speed: float = 700
var moving_to_target: bool = false

signal reached_target

func _ready() -> void:
	target_position = global_position

func _process(delta: float) -> void:
	global_position = global_position.move_toward(target_position, speed * delta)
	if global_position.distance_to(target_position) == 0 and moving_to_target:
		reached_target.emit()
		moving_to_target = false

func set_target(target: Vector2) -> void:
	target_position = target
	moving_to_target = true
