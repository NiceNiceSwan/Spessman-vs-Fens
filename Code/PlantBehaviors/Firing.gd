class_name Firing extends PlantBehavior

var bullets_per_fire: int = 1
## Amount of times this fires per second
var fire_delay: float = 1
var projectile: Projectiles
var projectile_scene: PackedScene = preload("uid://c8c0jxf63waum")
var _range: int = 1
var ready_to_fire: bool = true

var fire_delay_milliseconds: int
var burst_shots_fired: int = 0

@export var resource: Shooters

@onready var firing_timer: Timer = $FiringTimer
@onready var fire_sound: AudioStreamPlayer = $FireSound
@onready var detection_ray: RayCast2D = $DetectionRay
@onready var burst_fire_timer: Timer = $BurstFireTimer

signal reloaded
signal fired
signal detected_enemy

func _ready():
	if not resource:
		push_warning("Instantiating firing node without any data!")
		return

	bullets_per_fire = resource.bullets_per_fire
	fire_delay = resource.fire_delay
	projectile = resource.projectile
	if resource.projectile_scene:
		projectile_scene = resource.projectile_scene
	_range = resource.detection_range
	fire_sound.stream = resource.fire_sound
	
	firing_timer.wait_time = fire_delay
	
	var max_ray_range: float
	var board_edge: float = get_viewport().get_visible_rect().size.x - Defines.TILE_MAP_X_OFFSET
	max_ray_range = board_edge - global_position.x
	
	detection_ray.target_position.x = min(Defines.TILE_SIZE * _range + Defines.TILE_MAP_X_OFFSET, max_ray_range)

func _process(delta):
	if detection_ray.is_colliding():
		detected_enemy.emit()
		while fire_delay_milliseconds > 0:
			fire_delay_milliseconds -= 1 * (delta * 1000)
			return
		
		fire()

func fire(forced: bool = false, play_sound: bool = true):
	if not ready_to_fire and not forced:
		return
	
	var new_projectile: Projectile = projectile_scene.instantiate()
	new_projectile.projectile_data = projectile
	get_tree().current_scene.add_child(new_projectile)
	new_projectile.global_position = global_position
	
	if play_sound:
		fire_sound.play()
	
	ready_to_fire = false
	firing_timer.start()
	fired.emit()
	burst_fire_timer.start()

func _on_firing_timer_timeout() -> void:
	ready_to_fire = true
	fire_delay_milliseconds = randi_range(0, 50)
	burst_fire_timer.start()
	reloaded.emit()

func _on_burst_fire_timer_timeout() -> void:
	burst_shots_fired += 1
	if burst_shots_fired < bullets_per_fire:
		ready_to_fire = true
		fire_delay_milliseconds = randi_range(0, 50)
		reloaded.emit()
	else:
		burst_fire_timer.stop()
		burst_shots_fired = 0
