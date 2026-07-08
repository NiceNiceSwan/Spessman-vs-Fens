class_name Healing extends PlantBehavior

## the health below which the tower in front of this must be to start healing
var healing_threshold: float = 0.8
var can_heal: bool = true
var healing_projectile_data: HealingProjectilesResource
#var healing_projectile_scene: HealingProjectile

@export var healing_resource: HealingResource
@onready var detection_ray: RayCast2D = $HealDetectionRay
@onready var healing_timer: Timer = $HealTimer

func _ready() -> void:
	healing_threshold = healing_resource.healing_threshold
	healing_timer.wait_time = healing_resource.healing_delay
	healing_projectile_data = healing_resource.healing_projectile

func _process(_delta: float) -> void:
	var tower_to_track: Plant
	if detection_ray.is_colliding():
		tower_to_track = detection_ray.get_collider().get_parent()
		if (tower_to_track.health / tower_to_track.max_health) <= healing_threshold:
			heal()

func heal() -> void:
	if not can_heal:
		return

	var new_projectile: HealingProjectile = preload("uid://b1bbldip3pnh4").instantiate()
	new_projectile.projectile_data = healing_projectile_data
	get_tree().current_scene.add_child(new_projectile)
	new_projectile.global_position = global_position
	healing_timer.start()
	can_heal = false

func _on_heal_timer_timeout() -> void:
	can_heal = true
