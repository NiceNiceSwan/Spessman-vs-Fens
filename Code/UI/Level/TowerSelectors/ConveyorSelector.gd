class_name ConveyorSelector extends Control

const PLANT_HOLDER: PackedScene = preload("uid://chlj85f22rb4l")
const FADE_IN_SHADER: Shader = preload("uid://fa08yi6uu4fh")
const MOVE_SPEED: float = 80

## List of towers that this thing can spawn
@export var available_towers: Array[PackedScene]

@onready var conveyor_start: Marker2D = $ConveyorStart
@onready var conveyor_end: Marker2D = $ConveyorEnd
@onready var button_spawn_timer: Timer = $ButtonSpawnTimer

func _ready() -> void:
	Signals.plant_placed.connect(_on_tower_placed)

func _process(delta: float) -> void:
	var index: int
	for buy_button: PlantHolder in conveyor_start.get_children():
		var speed: float = MOVE_SPEED * delta
		var target_position: Vector2 = conveyor_end.position
		index = buy_button.get_index()
		target_position.x += 32 * index
		buy_button.global_position = buy_button.global_position.move_toward(target_position, speed)
	
	if index > 9:
		button_spawn_timer.stop()

func _on_button_spawn_timer_timeout() -> void:
	var plant_to_spawn: PackedScene = available_towers.pick_random()
	var new_plant_holder: PlantHolder = PLANT_HOLDER.instantiate()
	new_plant_holder.cost_visible = false
	new_plant_holder.plant_scene = plant_to_spawn
	new_plant_holder.position = Vector2(0, 0)
	
	var plant_holder_material: ShaderMaterial = ShaderMaterial.new()
	plant_holder_material.set_shader(FADE_IN_SHADER)
	new_plant_holder.material = plant_holder_material
	
	conveyor_start.add_child(new_plant_holder)

func _on_tower_placed(plant_slot: int) -> void:
	conveyor_start.get_child(plant_slot).queue_free()
