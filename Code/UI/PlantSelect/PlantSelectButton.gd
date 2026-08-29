class_name PlantSelectButton extends Control

const MOVE_SPEED_COEFFICIENT: int = 10

@export var plant_data: PlantData
@export var plant_scene: PackedScene = load("res://Code/Plants/Plant.tscn")
@export var unlock_data: Unlockable

var enabled: bool = false
var selected: bool = false
var original_position: Vector2
var target_position: Vector2
var speed: Vector2 = Vector2(0, 0)
var vertical_distance: float = 0

@onready var select_button: Button = $SelectButton
@onready var tower_icon: TextureRect = $SelectButton/VBoxContainer/TowerIcon
@onready var cost_label: Label = $SelectButton/VBoxContainer/MarginContainer/Cost
@onready var border_panel: Panel = $BorderPanel
@onready var symbol: TextureRect = $Symbol

signal select(called_button: PlantSelectButton)
signal unselect(called_button: PlantSelectButton)

func _ready() -> void:
	enabled = SaveData.unlocked_plants >= unlock_data.ID
	if not enabled:
		select_button.set_disabled(true)
		tower_icon.set_modulate(Color(0.3, 0.3, 0.3, 1))
	
	tower_icon.texture = unlock_data.texture
	cost_label.text = str(plant_data.cost)
	
	_load_card_style()

func _load_card_style() -> void:
	var button_style: SelectButtonStyle = plant_data.select_button_style
	var style_box: StyleBoxFlat = border_panel.get_theme_stylebox("panel").duplicate()
	style_box.set_border_color(button_style.border_color)
	border_panel.add_theme_stylebox_override("panel", style_box)
	
	style_box = select_button.get_theme_stylebox("normal").duplicate()
	style_box.set_bg_color(button_style.background_color)
	select_button.add_theme_stylebox_override("normal", style_box)
	
	style_box = select_button.get_theme_stylebox("hover").duplicate()
	var hover_color: Color = button_style.background_color
	hover_color.a = 0.6
	style_box.set_bg_color(hover_color)
	select_button.add_theme_stylebox_override("hover", style_box)
	
	symbol.texture = button_style.icon

func _process(delta: float) -> void:
	position = position.move_toward(target_position, (speed * delta).length())

func _on_select_button_pressed() -> void:
	if selected:
		unselect.emit(self)
	else:
		original_position = position
		target_position = position
		select.emit(self)

func start_moving(x_coordinate: float) -> void:
	target_position.x = x_coordinate
	target_position.y = -global_position.y
	vertical_distance = -global_position.y
	speed = (target_position - position) * MOVE_SPEED_COEFFICIENT
	selected = !selected

func shift_left(x_coordinate: float) -> void:
	target_position.x = x_coordinate
	target_position.y = vertical_distance
	speed = (target_position - position) * MOVE_SPEED_COEFFICIENT

func return_back() -> void:
	target_position = original_position
	speed = (target_position - position) * MOVE_SPEED_COEFFICIENT
	selected = !selected
