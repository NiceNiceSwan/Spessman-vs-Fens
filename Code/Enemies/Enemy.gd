class_name Enemy extends Node2D

@export var enemy_resource: EnemyResource

var health: float = 10
var damage: float = 1
var speed: float = 25
var attack_delay: float = 0.5
var attacking: bool = false
var target_plant: Plant
## Whether the enemy has passed the entry point and can be seen on the map.
var has_entered_board: bool = false

## Multiplier to the movement speed. Higher values means we move faster.
var move_speed_modifier: float = 1
## Multiplier to the attack speed. Higher values means we attack less 
## frequently.
var attack_speed_modifier: float = 1
var status_effects: Array[StatusEffect]

@onready var attack_timer: Timer = $AttackTimer
@onready var detection_ray: RayCast2D = $DetectionRay
@onready var sprite: Sprite2D = $Sprite2D
@onready var status_effects_holder: Node = $StatusEffects
@onready var hitbox_shape: CollisionShape2D = $Hitbox/HitboxShape
@onready var hit_sound: AudioStreamPlayer = $HitSound

signal died
signal game_over

func _ready() -> void:
	if global_position.x < (1280+128):
		hitbox_shape.set_disabled(false)
	else:
		hitbox_shape.set_disabled(true)

	if not enemy_resource:
		return
	
	initialize()

func _process(_delta: float) -> void:
	if global_position.x > (1280+128) and not has_entered_board:
		_enable_hitbox()
	
	if detection_ray.is_colliding() and not attacking:
		attacking = true
		var collider_area: Area2D = detection_ray.get_collider()
		if collider_area is Area2D:
			target_plant = collider_area.get_parent()
			attack_timer.start(attack_delay * attack_speed_modifier)

func _physics_process(delta: float) -> void:
	if not attacking:
		position.x -= speed * move_speed_modifier * delta

	if position.x <= 16:
		game_over.emit()

func initialize() -> void:
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

func on_hit(_damage: float) -> void:
	hit_animation()
	health -= _damage
	if health <= 0:
		die()
	hit_sound.play()

func hit_animation() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 0.2, 0.2, 1), 0.05) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.05) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)

func die() -> void:
	if is_queued_for_deletion():
		return
	died.emit()
	queue_free()

func _enable_hitbox() -> void:
		hitbox_shape.set_disabled(false)
		has_entered_board = true

func _on_attack_timer_timeout() -> void:
	if is_instance_valid(target_plant):
		target_plant.take_damage(damage)
		attack_timer.start(attack_delay * attack_speed_modifier)
		return
	
	attacking = false
	target_plant = null
	attack_timer.stop()
