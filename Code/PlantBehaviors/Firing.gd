class_name Firing extends Node

var bullets_per_fire: int = 1
## Amount of times this fires per second
var fire_delay: float = 1
var projectile: Projectiles
var _range: int = 1
var ready_to_fire: bool = true
var global_position: Vector2

var fire_delay_milliseconds: int

@export var resource: Shooters

@onready var firing_timer: Timer = $FiringTimer
@onready var fire_sound: AudioStreamPlayer = $FireSound
@onready var detection_ray: RayCast2D = $DetectionRay

signal behavior_action
signal reloaded

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
	detection_ray.global_position = global_position
	
	var max_ray_range: float
	var board_edge: float = get_viewport().get_visible_rect().size.x - Defines.TILE_MAP_X_OFFSET
	max_ray_range = board_edge - global_position.x
	
	detection_ray.target_position.x = min(Defines.TILE_SIZE * _range, max_ray_range)

func _process(delta):
	if not ready_to_fire:
		return
	
	#if detection_area.has_overlapping_areas():
	if detection_ray.is_colliding():
		while fire_delay_milliseconds > 0:
			fire_delay_milliseconds -= 1 * (delta * 1000)
			return
		
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
	fire_delay_milliseconds = randi_range(0, 50)
	reloaded.emit()
