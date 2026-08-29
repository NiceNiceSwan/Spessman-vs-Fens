class_name FreezeAll extends PlantBehavior

## Class representing a behavior which freezes all enemies on screen
## and applies a slow effect on them. Not very modular rn.

const SLOWDOWN_SCENE: PackedScene = preload("uid://bqqsgca2ug8rx")
const FREEZE_SCENE: PackedScene = preload("uid://bl5tcyg6k8lg")

## Time in seconds between the spawn time and effect application
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var time_to_act: float = 1
## How long the freeze will last, in seconds
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var freeze_duration: float = 5
## How long the slowdown will last, in seconds. If this is shorter than freeze duration,
## the slow does not persist after freeze expires.
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var slow_duration: float = 10
## Timer between this node being born and the effect being applied
@onready var action_timer: Timer = $ActionTimer
@onready var use_sound: AudioStreamPlayer2D = $UseSound

signal freezed

func _ready() -> void:
	action_timer.wait_time = time_to_act

func _on_action_timer_timeout() -> void:
	var level_node: Level = get_tree().current_scene
	var enemies_holder: Node = level_node.enemies
	for enemy: Enemy in enemies_holder.get_children():
		_apply_effects(enemy)
	
	freezed.emit()

func _apply_effects(enemy: Enemy) -> void:
	var slowdown: Slowdown = SLOWDOWN_SCENE.instantiate()
	slowdown.duration_time = slow_duration
	enemy.add_child(slowdown)
	slowdown.apply(enemy)
	
	var freeze: Freeze = FREEZE_SCENE.instantiate()
	freeze.duration_time = freeze_duration
	enemy.add_child(freeze)
	freeze.apply(enemy)
