class_name Enemy extends Node2D

@export var enemy_resource: EnemyResource

var health: float = 10
var damage: float = 1
var speed: float = 25
var attack_delay: float = 0.5
var attacking: bool = false
var target_plant: Plant

var move_speed_modifier: float = 1
var attack_speed_modifier: float = 1
var status_effects: Array[StatusEffect]

@onready var attack_timer: Timer = $AttackTimer
@onready var detection_ray: RayCast2D = $DetectionRay
@onready var sprite: Sprite2D = $Sprite2D
@onready var status_effects_holder: Node = $StatusEffects
@onready var hitbox_shape: CollisionShape2D = $Hitbox/HitboxShape

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
	var texture_size: Vector2 = sprite.texture.get_size()
	var rectangle_shape: RectangleShape2D = RectangleShape2D.new()
	rectangle_shape.set_size(Vector2(texture_size.x, 126))
	hitbox_shape.shape = rectangle_shape
	
	if texture_size.y > 128:
		sprite.position.y -= (texture_size.y - 128) / 2
	
	detection_ray.position.x = texture_size.x / 2
	detection_ray.target_position.x = -texture_size.x

func on_hit(_damage: float):
	health -= _damage
	if health <= 0:
		die()
	$HitSound.play()

func die():
	if is_queued_for_deletion():
		return
	died.emit()
	queue_free()

func _process(_delta):
	if detection_ray.is_colliding() and not attacking:
		attacking = true
		target_plant = detection_ray.get_collider().get_parent()
		attack_timer.start(attack_delay * attack_speed_modifier)
		return

func _physics_process(delta: float) -> void:
	if not attacking:
		position.x -= speed * move_speed_modifier * delta

	if position.x <= 16:
		game_over.emit()

func _on_attack_timer_timeout():
	if is_instance_valid(target_plant):
		target_plant.take_damage(damage)
		attack_timer.start(attack_delay * attack_speed_modifier)
		return
	
	attacking = false
	target_plant = null
	attack_timer.stop()
