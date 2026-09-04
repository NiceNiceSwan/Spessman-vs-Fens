class_name OneUse extends PlantBehavior

var damage: int = 250
var _range: int = 1
var detection_range: int = 1
var armed: bool = false
var arming_time: int = 30
var delay_explosion: bool = false
var instant_explosion: bool = false

@export var resource: OneUseResource

@onready var explosion_area: Area2D = $ExplosionArea
@onready var explosion_collision: CollisionShape2D = $ExplosionArea/ExplosionArea
@onready var arming_timer: Timer = $ArmingTimer
@onready var use_sound: AudioStreamPlayer2D = $UseSound
@onready var detection_ray: RayCast2D = $DetectionRay
var exploded: bool = false

signal finished_arming
signal explode
signal wants_to_explode

func _ready() -> void:
	if not resource:
		push_warning("Instantiating OneUse without any data!")
		arming_timer.start()
		return
	
	damage = resource.damage
	_range = resource._range
	armed = resource.armed
	arming_time = resource.arming_time
	delay_explosion = resource.delayed_explosion
	instant_explosion = resource.instant_explosion
	
	var max_ray_range: float
	var board_edge: float = get_viewport().get_visible_rect().size.x - Defines.TILE_MAP_X_OFFSET
	max_ray_range = board_edge - global_position.x
	
	detection_ray.target_position.x = min(Defines.TILE_SIZE * (detection_range - 1) + 66, max_ray_range)
	
	if arming_time > 0:
		arming_timer.wait_time = arming_time
		arming_timer.start()
	
	var rectangle_shape: RectangleShape2D = RectangleShape2D.new()
	rectangle_shape.set_size(Vector2((_range * 128) + 64, (_range * 128) - 2))
	explosion_collision.shape = rectangle_shape

#func _process(_delta):
func _physics_process(_delta: float) -> void:
	if not armed:
		if not delay_explosion:
			armed = true
		return
	
	if detection_ray.is_colliding() or instant_explosion:
		if delay_explosion:
			_prepare_explosion()
			return
		_detonate()

func _prepare_explosion() -> void:
	wants_to_explode.emit()

func _detonate() -> void:
	if exploded:
		return
	exploded = true

	for detected_area: Area2D in explosion_area.get_overlapping_areas():
		var enemy: Enemy = detected_area.get_parent()
		enemy.on_hit(damage)
	
	explode.emit()
	
func _on_arming_timer_timeout() -> void:
	if instant_explosion:
		_detonate()
	armed = true
	finished_arming.emit()
