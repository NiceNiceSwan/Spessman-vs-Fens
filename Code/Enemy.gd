class_name Enemy extends Node2D

@export var enemy_resource: EnemyResource

var health: float = 10
var damage: float = 1
var speed: float = 25
var attack_delay: float = 0.5
var attacking: bool = false
var target_plant: Plant

var move_speed_modifier: float = 1
var status_effects: Array[StatusEffect]

@onready var attack_timer: Timer = $AttackTimer
@onready var detection_ray: RayCast2D = $DetectionRay
@onready var sprite: Sprite2D = $Sprite2D
@onready var status_effects_holder: Node = $StatusEffects

signal died
signal game_over

func _ready():
	if not enemy_resource:
		return
	
	initialize()

func initialize():
	health = enemy_resource.health
	damage = enemy_resource.damage
	speed = enemy_resource.speed
	attack_delay = enemy_resource.attack_delay
	sprite.texture = enemy_resource.texture

func on_hit(_damage: float):
	health -= _damage
	if health <= 0:
		died.emit()
		queue_free()
	$HitSound.play()

func _process(delta):
	if detection_ray.is_colliding() and not attacking:
		attacking = true
		target_plant = detection_ray.get_collider().get_parent()
		attack_timer.start(attack_delay)
		return
	
	if not attacking:
		var move_speed: float = speed * move_speed_modifier * delta
		position -= Vector2(speed * move_speed_modifier * delta, 0)
	
	if position.x <= 16:
		game_over.emit()

func _on_attack_timer_timeout():
	if is_instance_valid(target_plant):
		target_plant.health -= damage
		return
	
	attacking = false
	target_plant = null
	attack_timer.stop()
