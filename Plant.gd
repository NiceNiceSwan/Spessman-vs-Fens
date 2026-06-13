class_name Plant extends Node2D

var health: float = 5
var cost: int = 100
@export var plant_data: PlantData

func initialize():
	name = plant_data.name
	health = plant_data.max_health
	cost = plant_data.cost
	$Sprite2D.texture = plant_data.texture
	for behavior in plant_data.behaviors:
		var behavior_node = behavior.node.instantiate()
		behavior_node.resource = behavior.resource
		behavior_node.behavior_action.connect(after_behavior)
		add_child(behavior_node)

func initialize_with_position(position: Vector2):
	global_position = position
	
	initialize()

func _process(delta):
	if health <= 0:
		get_tree().current_scene.kill_plant(global_position)
		queue_free()

func after_behavior():
	$Sprite
