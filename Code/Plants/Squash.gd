class_name Squash extends Explosive

var speed: Vector2 = Vector2(0, 0)
var offset_position: Vector2 = Vector2(0, 0)
var is_tweening: bool = false

@onready var death_timeout: Timer = $DeathTimeout

func _ready() -> void:
	super()
	animated_sprite.set_animation("default")
	animated_sprite.stop()

func _on_one_use_wants_to_explode() -> void:
	_play_squash_animation()

func _play_squash_animation() -> void:
	if is_tweening:
		return

	is_tweening = true
	var original_position: Vector2 = animated_sprite.position
	var target_position: Vector2 = original_position
	target_position.x += 96
	target_position.y -= 96
	
	var tween: Tween = create_tween()
	tween.tween_property(animated_sprite, "position", target_position, 0.5) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)
	
	target_position = original_position
	target_position.x += 96
	
	tween.tween_property(animated_sprite, "position", target_position, 0.1) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(func() -> void: one_use_node._detonate())

func _on_one_use_explode() -> void:
	plant_died.emit(global_position)
	death_timeout.start()

func _on_death_timeout_timeout() -> void:
	_die()
