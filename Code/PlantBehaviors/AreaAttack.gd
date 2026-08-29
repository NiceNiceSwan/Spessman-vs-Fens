class_name AreaAttack extends PlantBehavior

var fire_delay_milliseconds: float = 0
var damage: float = 3

@export var resource: AreaAttackResource

@onready var attack_timer: Timer = $AttackTimer
@onready var attack_sound: AudioStreamPlayer = $AttackSound
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_area: Area2D = $AttackArea
@onready var attack_sprite: AnimatedSprite2D = $AttackSprite
@onready var detection_area_shape: CollisionShape2D = $DetectionArea/DetectionAreaShape
@onready var attack_area_shape: CollisionShape2D = $AttackArea/AttackAreaShape

func _ready() -> void:
	fire_delay_milliseconds = randi_range(0, 50)
	if not resource:
		return
	
	initialize_data_from_resource()

func initialize_data_from_resource() -> void:
	damage = resource.damage
	
	var attack_area_rect: RectangleShape2D = RectangleShape2D.new()
	attack_area_rect.set_size(Vector2(
		resource.attack_range * 128,
		resource.attack_range * 128)
		)
	attack_area_shape.shape = attack_area_rect
	
	var detection_area_rect: RectangleShape2D = RectangleShape2D.new()
	detection_area_rect.set_size(Vector2(
		(resource.detection_range * 128),
		(resource.detection_range * 128))
		)
	detection_area_shape.shape = detection_area_rect

func _process(delta: float) -> void:
	if not detection_area.has_overlapping_areas():
		return
	
	if not attack_timer.is_stopped():
		return
		
	if fire_delay_milliseconds > 0:
		fire_delay_milliseconds -= 1 * (delta * 1000)
		return
	
	fire_delay_milliseconds = randi_range(0, 50)
	attack_timer.start()
	attack_sprite.set_visible(true)
	attack_sprite.play()
	
	for area: Area2D in attack_area.get_overlapping_areas():
		var enemy: Enemy = area.get_parent()
		enemy.on_hit(damage)

func _on_attack_sprite_animation_finished() -> void:
	attack_sprite.set_visible(false)
