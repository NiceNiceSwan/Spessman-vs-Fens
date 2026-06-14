class_name Plant extends Node2D

var health: float = 5
var cost: int = 100
@export var plant_data: PlantData
var _name: String = "Plant"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

signal plant_died(position: Vector2)

func _ready():
	initialize()

func initialize():
	_name = plant_data.name
	health = plant_data.max_health
	cost = plant_data.cost
	animated_sprite.sprite_frames = plant_data.sprite_frames
	for behavior in plant_data.behaviors:
		var behavior_node = behavior.node.instantiate()
		behavior_node.resource = behavior.resource
		behavior_node.behavior_action.connect(after_behavior)
		add_child(behavior_node)

func _process(delta):
	if health <= 0:
		#get_tree().current_scene.kill_plant(global_position)
		plant_died.emit(global_position)
		queue_free()

func after_behavior():
	animated_sprite.play()
