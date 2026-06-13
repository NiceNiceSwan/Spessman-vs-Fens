class_name Projectile extends Area2D

## movespeed in pixels per second
var speed: int = 100
var damage: float = 1

@export var projectile_data: Projectiles

func _ready():
	if not projectile_data:
		push_warning("Projectile initialized without any data! Using default values!")
		return
	
	speed = projectile_data.speed
	damage = projectile_data.damage

func _process(delta):
	position += Vector2(speed, 0) * delta
	if position.x > 2000:
		queue_free()
	rotation_degrees += 360 * delta

func _hit() -> float:
	queue_free()
	return damage

func _on_life_timer_timeout():
	queue_free()
