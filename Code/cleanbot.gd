class_name cleanbot extends Node2D

@export var speed: int = 500

var activated: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_ray: RayCast2D = $StartRayCast

func _process(delta: float) -> void:
	var enemy: Enemy
	if detection_ray.is_colliding():
		if not activated:
			sprite.set_animation("flying")
			sprite.play()
		activated = true
		if is_instance_valid(detection_ray.get_collider()):
			var detected_area: Area2D = detection_ray.get_collider()
			enemy = detected_area.get_parent()
	
	if not activated:
		return
	
	if enemy:
		enemy.die()
	
	position += Vector2(speed, 0) * delta
	if position.x > 2000:
		queue_free()
