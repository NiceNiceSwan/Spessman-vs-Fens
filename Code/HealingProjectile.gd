class_name HealingProjectile extends Area2D

## movespeed in pixels per second
var speed: int = 100
var _range: int = 1
## Does this projectile rotate while it flies
var rotates: bool = false
var healing_percentage: float = 0.2
var absolute_healing: float = 0

var parent_area: Area2D

var starting_position: Vector2

@export var projectile_data: HealingProjectilesResource

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var status_effects: Node = $StatusEffects

func _ready() -> void:
	if not projectile_data:
		push_warning("Healing Projectile initialized without any data! Using default values!")
		return
	
	speed = projectile_data.speed
	rotates = projectile_data.rotates
	_range = projectile_data.fly_range
	healing_percentage = projectile_data.healing_percentage
	absolute_healing = projectile_data.healing_absolute
	
	animated_sprite.sprite_frames = projectile_data.sprite_frames
	if animated_sprite.sprite_frames:
		animated_sprite.play()
	
	starting_position = position

func _process(delta: float) -> void:
	position += Vector2(speed, 0) * delta
	starting_position += Vector2(speed, 0) * delta
	var maximum_range: float = _range * Defines.TILE_SIZE + Defines.TILE_MAP_X_OFFSET
	if position.x > 2000 or starting_position.x > maximum_range:
		queue_free()
	
	if rotates:
		rotation_degrees += 360 * delta

func _on_life_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if not parent_area:
		parent_area = area
		return
	if parent_area == area:
		return
	var plant: Plant = area.get_parent()
	var relative_healing: float = plant.max_health * healing_percentage
	plant.take_damage(-absolute_healing)
	plant.take_damage(-relative_healing)
	queue_free()
