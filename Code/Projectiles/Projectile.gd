class_name Projectile extends Area2D

## movespeed in pixels per second
var speed: int = 100
var damage: float = 1
var health: int = 1
var _range: int = 9
## Does this projectile rotate while it flies
var rotates: bool = true

var starting_position: Vector2

@export var projectile_data: Projectiles

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var status_effects: Node = $StatusEffects

signal killed_enemy

func _ready():
	if not projectile_data:
		push_warning("Projectile initialized without any data! Using default values!")
		return
	
	speed = projectile_data.speed
	damage = projectile_data.damage
	rotates = projectile_data.rotates
	health = projectile_data.health
	_range = projectile_data.fly_range
	starting_position = position
	
	animated_sprite.sprite_frames = projectile_data.sprite_frames
	if animated_sprite.sprite_frames:
		animated_sprite.play()

func _process(delta):
	#position += Vector2(speed, 0) * delta
	position += speed * delta * Vector2.RIGHT.rotated(rotation)
	#Vector2.UP.rotated(rotation)
	starting_position += Vector2(speed, 0) * delta
	var maximum_range: float = _range * Defines.TILE_SIZE + Defines.TILE_MAP_X_OFFSET
	if position.x > 2000 or starting_position.x > maximum_range:
		queue_free()
	
	if rotates:
		animated_sprite.rotation_degrees += 360 * delta

func _hit() -> float:
	health -= 1
	if health <= 0:
		queue_free()
	return damage

func _on_life_timer_timeout():
	queue_free()

func _on_area_entered(area: Area2D):
	if health <= 0:
		return
	
	var enemy: Enemy = area.get_parent()
	enemy.on_hit(_hit())
	
	if enemy.health <= 0:
		killed_enemy.emit()

	for child: StatusEffect in status_effects.get_children():
		child.apply(enemy)
