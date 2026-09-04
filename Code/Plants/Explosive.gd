class_name Explosive extends Plant

@onready var one_use_node: OneUse = $OneUse

func _ready() -> void:
	super()
	if animated_sprite.sprite_frames.has_animation("arming"):
		animated_sprite.set_animation("arming")

func _on_animated_sprite_animation_finished() -> void:
	animated_sprite.animation_finished.disconnect(_on_animated_sprite_animation_finished)
	animated_sprite.set_animation("armed")
	animated_sprite.play()

func _on_one_use_explode() -> void:
	animated_sprite.set_animation("exploding")
	animated_sprite.play()
	plant_died.emit(global_position)
	animated_sprite.animation_finished.connect(_die)

func _on_one_use_finished_arming() -> void:
	animated_sprite.play()
