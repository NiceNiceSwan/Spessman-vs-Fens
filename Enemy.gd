class_name Enemy extends Node2D

@export var health: float = 10
@export var damage: float = 1
@export var speed: float = 25
@export var attack_delay: float = 0.5
var attacking: bool = false
var target_plant: Plant

@onready var attack_timer: Timer = $AttackTimer
@onready var detection_ray: RayCast2D = $DetectionRay

func _on_hit(_damage: float):
	health -= _damage
	if health <= 0:
		queue_free()
	$HitSound.play()

func _process(delta):
	
	if detection_ray.is_colliding() and not attacking:
		attacking = true
		target_plant = detection_ray.get_collider().get_parent()
		attack_timer.start(attack_delay)
		return
	
	if not attacking:
		position -= Vector2(speed, 0) * delta

func _on_hitbox_area_entered(projectile: Projectile):
	if projectile.health > 0:
		_on_hit(projectile._hit())

func _on_attack_timer_timeout():
	if is_instance_valid(target_plant):
		target_plant.health -= damage
		return
	
	attacking = false
	target_plant = null
	attack_timer.stop()
