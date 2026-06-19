extends Control

@export var plant: PlantData
@export var plant_scene: PackedScene = load("res://Code/Plants/Plant.tscn")

@onready var index: int = get_index()
@onready var plant_delay: Timer = $PlantDelay
@onready var buy_button: Button = $Button
@onready var texture_rect: TextureRect = $Button/VBoxContainer/TextureRect

var wait_time: float = 1

func _ready():
	if not is_instance_valid(plant):
		plant = plant_scene.instantiate().plant_data
	
	wait_time = plant.plant_cooldown
	plant_delay.wait_time = wait_time
	$Button/VBoxContainer/Cost.text = str(plant.cost)
	texture_rect.texture = plant.sprite_frames.get_frame_texture("default", 0)
	Signals.plant_placed.connect(_on_plant_placed)

func _process(delta):
	if plant_delay.is_stopped():
		return
	
	var fill: float = 1 - plant_delay.time_left / wait_time

func _on_button_pressed():
	Signals.plant_selected.emit(plant, plant_scene, index)

func _on_plant_placed(plant_index: int):
	if plant_index == index:
		plant_delay.start()
		buy_button.set_disabled(true)
		texture_rect.set_modulate(Color(0.3, 0.3, 0.3, 1))

func _on_plant_delay_timeout():
	buy_button.set_disabled(false)
	texture_rect.set_modulate(Color(Color.WHITE))
