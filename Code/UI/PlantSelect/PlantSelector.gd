class_name PlantSelector extends Control

var number_of_plants: int = 0
var selected_plants: Array[PlantSelectButton]

const SLIDE_SPEED: int = 500
var slide_speed: int = 0

@onready var selected_plants_panel: PanelContainer = $SelectedPlants
@onready var pickable_plants: PanelContainer = $PickablePlants
@onready var upper_plants_row: HBoxContainer = $PickablePlants/PlantsHolder/UpperPlantsRow
@onready var lower_plants_row: HBoxContainer = $PickablePlants/PlantsHolder/LowerPlantsRow
@onready var play_button: Button = $PlayButton
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var view_timer: Timer = $ViewTimer

signal play_button_pressed(selected_plants: Array[PlantSelectButton])

func _ready() -> void:
	selected_plants_panel.set_visible(false)
	pickable_plants.set_visible(false)
	for children: PlantSelectButton in upper_plants_row.get_children():
		children.select.connect(on_plant_selected)
		children.unselect.connect(on_plant_unselected)
	for children: PlantSelectButton in lower_plants_row.get_children():
		children.select.connect(on_plant_selected)
		children.unselect.connect(on_plant_unselected)
	
	selected_plants_panel.position.x -= selected_plants_panel.size.x
	pickable_plants.position.x -= pickable_plants.size.x
	if SaveData.unlocked_plants < Enums.UNLOCKS.SQUASH:
		play_button.set_visible(false)

func _process(delta: float) -> void:
	var selected_panel_position_y: float = selected_plants_panel.position.y
	var pickable_plants_position_y: float = pickable_plants.position.y
	selected_plants_panel.position = selected_plants_panel.position.move_toward(Vector2(0, selected_panel_position_y), slide_speed * delta)
	pickable_plants.position = pickable_plants.position.move_toward(Vector2(0, pickable_plants_position_y), slide_speed * delta)

func slide_panels_in() -> void:
	# Squash is the 8th plant, and the first one after which we have more slots than plants
	if SaveData.unlocked_plants < Enums.UNLOCKS.SQUASH:
		setup_default_plants()
		return
	
	selected_plants_panel.set_visible(true)
	pickable_plants.set_visible(true)
	slide_speed = SLIDE_SPEED

func setup_default_plants() -> void:
	for index in range(7):
		var plant_button: PlantSelectButton = upper_plants_row.get_children()[index]
		selected_plants.append(plant_button)
	view_timer.start()

func on_plant_selected(button: PlantSelectButton):
	if number_of_plants >= 7:
		return
	
	var resulting_position_x: float = number_of_plants * 64
	number_of_plants += 1
	selected_plants.append(button)
	button.start_moving(resulting_position_x)
	if number_of_plants >= 7:
		play_button.set_disabled(false)

func on_plant_unselected(button: PlantSelectButton):
	play_button.set_disabled(true)
	button.return_back()
	number_of_plants -= 1
	selected_plants.erase(button)
	for index in selected_plants.size():
		selected_plants[index].shift_left(index * 64)

func _on_pause_menu_button_pressed():
	if not get_tree().is_paused():
		get_tree().set_pause(true)
		pause_menu.set_visible(true)
		return
	
	get_tree().set_pause(false)
	pause_menu.disable()

func _on_play_button_pressed() -> void:
	play_button_pressed.emit(selected_plants)

func _on_view_timer_timeout() -> void:
	play_button_pressed.emit(selected_plants)
