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
@onready var texture_rect: TextureRect = $SelectButton/VBoxContainer/TextureRect
@onready var cost_label: Label = $SelectButton/VBoxContainer/Cost

signal select(called_button: PlantSelectButton)
signal unselect(called_button: PlantSelectButton)

func _ready() -> void:
	enabled = SaveData.unlocked_plants >= unlock_data.ID
	if not enabled:
		select_button.set_disabled(true)
		texture_rect.set_modulate(Color(0.3, 0.3, 0.3, 1))
	
	texture_rect.texture = unlock_data.texture
	cost_label.text = str(plant_data.cost)

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
