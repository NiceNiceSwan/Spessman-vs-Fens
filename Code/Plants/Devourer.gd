class_name Devourer extends Plant

var is_tweening: bool = false

@onready var money_maker_node: MoneyMaking = $MoneyMaking
@onready var digest_sound: AudioStreamPlayer = $DigestSound
@onready var firing_node: HitScan = $HitScan

func initialize():
	super()
	firing_node.reloaded.connect(_reset_animation)
	firing_node.fired.connect(after_behavior)

func after_behavior():
	_play_dash()
	animated_sprite.play()

func _play_dash():
	if is_tweening:
		return

	is_tweening = true
	var original_position: Vector2 = animated_sprite.position
	var target_pos: Vector2 = original_position
	target_pos.x += 228
	
	var tween = create_tween()
	tween.tween_property(animated_sprite, "position", target_pos, 0.1) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(animated_sprite, "position", original_position, 0.25) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(func(): is_tweening = false)

func _reset_animation():
	animated_sprite.stop()
	money_maker_node.create_money()
	digest_sound.play()
