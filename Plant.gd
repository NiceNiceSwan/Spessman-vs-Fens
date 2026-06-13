class_name Plant extends Node2D

var health: float = 5
var cost: int = 100
@export var plant_data: PlantData
var is_tweening: bool = false
var _name: String = "Plant"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func initialize():
	_name = plant_data.name
	health = plant_data.max_health
	cost = plant_data.cost
	animated_sprite.sprite_frames = plant_data.sprite_frames
	for behavior in plant_data.behaviors:
		var behavior_node = behavior.node.instantiate()
		behavior_node.resource = behavior.resource
		behavior_node.behavior_action.connect(after_behavior)
		if behavior_node.has_signal("after_cooldown"):
			behavior_node.after_cooldown.connect(_after_cooldown)
		add_child(behavior_node)

func initialize_with_position(position: Vector2):
	global_position = position
	
	initialize()

func _process(delta):
	if health <= 0:
		get_tree().current_scene.kill_plant(global_position)
		queue_free()

func after_behavior():
	animated_sprite.play()
	#print(name)
	if _name == "Devourer":
		_play_dash()

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

func _after_cooldown():
	animated_sprite.stop()
