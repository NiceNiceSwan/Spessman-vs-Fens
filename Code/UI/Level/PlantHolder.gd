class_name PlantHolder extends Control

@export var plant: PlantData
@export var plant_scene: PackedScene = load("res://Code/Plants/Plant.tscn")

@onready var index: int = get_index()
@onready var plant_delay: Timer = $PlantDelay
@onready var buy_button: Button = $Button
@onready var texture_rect: TextureRect = $Button/VBoxContainer/TextureRect
@onready var cost: Label = $Button/VBoxContainer/Cost
@onready var border_panel: Panel = $BorderPanel
@onready var symbol: TextureRect = $Symbol

var wait_time: float = 1

func _ready():
	if not is_instance_valid(plant):
		plant = plant_scene.instantiate().plant_data
	
	wait_time = plant.plant_cooldown
	plant_delay.wait_time = wait_time
	cost.text = str(plant.cost)
	texture_rect.texture = plant.sprite_frames.get_frame_texture("default", 0)
	Signals.plant_placed.connect(_on_plant_placed)
	
	_load_card_style()

func _load_card_style() -> void:
	var button_style: SelectButtonStyle = plant.select_button_style
	var style_box: StyleBoxFlat = border_panel.get_theme_stylebox("panel").duplicate()
	style_box.set_border_color(button_style.border_color)
	border_panel.add_theme_stylebox_override("panel", style_box)
	
	style_box = buy_button.get_theme_stylebox("normal").duplicate()
	style_box.set_bg_color(button_style.background_color)
	buy_button.add_theme_stylebox_override("normal", style_box)
	
	style_box = buy_button.get_theme_stylebox("hover").duplicate()
	var hover_color: Color = button_style.background_color
	hover_color.a = 0.6
	style_box.set_bg_color(hover_color)
	buy_button.add_theme_stylebox_override("hover", style_box)
	
	symbol.texture = button_style.icon

func _process(_delta):
	if plant_delay.is_stopped():
		return

func reload() -> void:
	wait_time = plant.plant_cooldown
	plant_delay.wait_time = wait_time
	cost.text = str(plant.cost)
	texture_rect.texture = plant.sprite_frames.get_frame_texture("default", 0)

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
