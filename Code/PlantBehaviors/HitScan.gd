class_name HitScan extends PlantBehavior

## Amount of times this fires per second
var fire_delay: float = 1
var _range: int = 1
var damage: int = 1
var ready_to_fire: bool = true

@export var resource: HitScanResource

@onready var firing_timer: Timer = $FiringTimer
@onready var fire_sound: AudioStreamPlayer = $FireSound
@onready var detection_ray: RayCast2D = $DetectionRay

signal reloaded
signal fired
signal detected_enemy

func _ready():
	if not resource:
		push_warning("Instantiating hitscan node without any data!")
		return

	fire_delay = resource.fire_delay
	_range = resource._range
	fire_sound.stream = resource.attack_sound
	damage = resource.damage
	
	firing_timer.wait_time = fire_delay
	
	var max_ray_range: float
	var board_edge: float = get_viewport().get_visible_rect().size.x - Defines.TILE_MAP_X_OFFSET
	max_ray_range = board_edge - global_position.x
	
	detection_ray.target_position.x = min(Defines.TILE_SIZE * _range + Defines.TILE_MAP_X_OFFSET, max_ray_range)

func _process(delta):
	if detection_ray.is_colliding():
		detected_enemy.emit()
		if is_instance_valid(detection_ray.get_collider()):
			var enemy: Enemy = detection_ray.get_collider().get_parent()
			fire(enemy)

func fire(enemy: Enemy, forced: bool = false, play_sound: bool = true):
	if not ready_to_fire and not forced:
		return
	
	if play_sound:
		fire_sound.play()
	
	enemy.on_hit(damage)
	ready_to_fire = false
	firing_timer.start()
	fired.emit()

func _on_firing_timer_timeout():
	ready_to_fire = true
	reloaded.emit()
