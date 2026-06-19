class_name OneUse extends PlantBehavior

var damage: int = 250
var _range: int = 1
var detection_range: int = 1
var armed: bool = true
var arming_time: int = 30
var delay_explosion: bool = false

@export var resource: OneUseResource

@onready var explosion_area: Area2D = $ExplosionArea
@onready var explosion_collision: CollisionShape2D = $ExplosionArea/ExplosionArea
@onready var arming_timer: Timer = $ArmingTimer
@onready var use_sound: AudioStreamPlayer2D = $UseSound
@onready var detection_ray: RayCast2D = $DetectionRay

signal finished_arming
signal explode
signal wants_to_explode

func _ready():
	if not resource:
		push_warning("Instantiating OneUse without any data!")
		arming_timer.start()
		return
	
	damage = resource.damage
	_range = resource.range
	armed = resource.armed
	arming_time = resource.arming_time
	delay_explosion = resource.delayed_explosion
	
	var max_ray_range: float
	var board_edge: float = get_viewport().get_visible_rect().size.x - Defines.TILE_MAP_X_OFFSET
	max_ray_range = board_edge - global_position.x
	
	detection_ray.target_position.x = min(Defines.TILE_SIZE * (detection_range - 1) + 64, max_ray_range)
	
	explosion_area.global_position = global_position
	if arming_time > 0:
		arming_timer.wait_time = arming_time
		arming_timer.start()

func _process(_delta):
	if not armed:
		return
	
	if detection_ray.is_colliding():
		if delay_explosion:
			_prepare_explosion()
			return
		_detonate()

func _prepare_explosion():
	wants_to_explode.emit()

func _detonate():
	explode.emit()
	for enemy in explosion_area.get_overlapping_areas():
		enemy.get_parent().on_hit(damage)
	
func _on_arming_timer_timeout():
	armed = true
	finished_arming.emit()
