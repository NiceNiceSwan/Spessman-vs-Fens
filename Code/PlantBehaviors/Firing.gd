class_name Firing extends Node

var bullets_per_fire: int = 1
## Amount of times this fires per second
var fire_rate: float = 1
var projectile: Projectiles
var _range: int = 1

@export var resource: Shooters

var global_position: Vector2
@onready var detection_area: Area2D = $DetectionArea
@onready var enemy_detector: CollisionShape2D = $DetectionArea/EnemyDetector

signal behavior_action

func _ready():
	if not resource:
		push_warning("Instantiating money maker without any data!")
		return

	bullets_per_fire = resource.bullets_per_fire
	fire_rate = resource.fire_rate
	projectile = resource.projectile
	_range = resource.range
	
	global_position = get_parent().global_position
	$firing_timer.wait_time = 1 / fire_rate
	detection_area.global_position = global_position
	enemy_detector.shape.set_size(Vector2(128 * _range, 128))
	enemy_detector.position.x = 64 * _range

func _on_firing_timer_timeout():
	if detection_area.has_overlapping_areas():
		#var new_projectile = projectile.instantiate() as Area2D
		var new_projectile: Projectile = load("res://Projectile.tscn").instantiate()
		new_projectile.projectile_data = projectile
		get_tree().current_scene.add_child(new_projectile)
		new_projectile.global_position = global_position
		$FireSound.play()
		behavior_action.emit()
