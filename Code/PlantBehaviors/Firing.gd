class_name Firing extends Node

var bullets_per_fire: int = 1
## Amount of times this fires per second
var fire_delay: float = 1
var projectile: Projectiles
var _range: int = 1
var ready_to_fire: bool = true
var global_position: Vector2

@export var resource: Shooters

@onready var detection_area: Area2D = $DetectionArea
@onready var enemy_detector: CollisionShape2D = $DetectionArea/EnemyDetector
@onready var firing_timer: Timer = $FiringTimer
@onready var fire_sound: AudioStreamPlayer = $FireSound

signal behavior_action
signal after_cooldown

func _ready():
	if not resource:
		push_warning("Instantiating money maker without any data!")
		return

	bullets_per_fire = resource.bullets_per_fire
	fire_delay = resource.fire_delay
	projectile = resource.projectile
	_range = resource.range
	fire_sound.stream = resource.fire_sound
	
	global_position = get_parent().global_position
	firing_timer.wait_time = fire_delay
	detection_area.global_position = global_position
	enemy_detector.shape.set_size(Vector2(128 * _range, 128))
	enemy_detector.position.x = 64 * _range

func _process(delta):
	if not ready_to_fire:
		return
	
	if detection_area.has_overlapping_areas():
		var new_projectile: Projectile = load("res://Projectile.tscn").instantiate()
		new_projectile.projectile_data = projectile
		get_tree().current_scene.add_child(new_projectile)
		new_projectile.global_position = global_position
		fire_sound.play()
		behavior_action.emit()
		firing_timer.start()
		ready_to_fire = false

func _on_firing_timer_timeout():
	ready_to_fire = true
	after_cooldown.emit()
