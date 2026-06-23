class_name HealthDoll extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite

func update_health(health_percent: float):
	@warning_ignore("integer_division")
	var frame: int = 6 - int(100 * health_percent / (100 / 6))
	sprite.set_frame_and_progress(frame, 0)
