class_name OneUse extends Node

var damage: int = 250
var _range: int = 1
var armed: bool = true
var arming_time: int = 1

var arming_animation_finished: bool = false

@export var resource: OneUseResource

var global_position: Vector2

@onready var detection_area: Area2D = $DetectionArea
@onready var enemy_detector: CollisionShape2D = $DetectionArea/DetectionShape
@onready var arming_timer: Timer = $ArmingTimer
@onready var use_sound: AudioStreamPlayer2D = $UseSound

var parent: Plant

signal behavior_action

func _ready():
	parent = get_parent()
	if not resource:
		push_warning("Instantiating money maker without any data!")
		arming_timer.start()
		return
	
	damage = resource.damage
	_range = resource.range
	armed = resource.armed
	arming_time = resource.arming_time
	
	global_position = parent.global_position
	detection_area.global_position = global_position
	if arming_time > 0:
		arming_timer.wait_time = arming_time
		arming_timer.start()

func _process(delta):
	if not armed:
		return
	
	if detection_area.has_overlapping_areas():
		for enemy in detection_area.get_overlapping_areas():
			#enemy._on_hit(damage)
			enemy.get_parent()._on_hit(damage)
		parent.queue_free()

func _on_arming_timer_timeout():
	if not arming_animation_finished:
		behavior_action.emit()
		arming_animation_finished = true
		arming_timer.wait_time = 1
		arming_timer.start()
	armed = true
