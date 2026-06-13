class_name Enemy extends Node2D

@export var health: float = 10
@export var damage: float = 1
@export var speed: float = 25
@export var attack_delay: float = 0.5
var attacking: bool = false
var target_plant: Plant
@onready var attack_timer: Timer = $AttackTimer

func _on_hit(_damage: float):
	health -= _damage
	if health <= 0:
		queue_free()
	$HitSound.play()

func _process(delta):
	if position.x <= 1280:
		$Hitbox/HitboxShape.disabled = false
	
	if not attacking:
		position -= Vector2(speed, 0) * delta

func _on_hitbox_area_entered(projectile: Projectile):
	_on_hit(projectile._hit())

func _on_attack_range_area_entered(area: Area2D):
	target_plant = area.get_parent()
	attacking = true
	attack_timer.start(attack_delay)

func _on_attack_timer_timeout():
	if is_instance_valid(target_plant):
		target_plant.health -= damage
		return
	
	attacking = false
	target_plant = null
	attack_timer.stop()
