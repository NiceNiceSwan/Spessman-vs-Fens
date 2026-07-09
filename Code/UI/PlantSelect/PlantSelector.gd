class_name PlantSelector extends Control

var number_of_plants: int = 0
var selected_plants: Array[PlantSelectButton]

@onready var upper_plants_row: HBoxContainer = $PanelContainer/PlantsHolder/UpperPlantsRow
@onready var play_button: Button = $PlayButton
@onready var pause_menu: PauseMenu = $PauseMenu

func _ready() -> void:
	for children: PlantSelectButton in upper_plants_row.get_children():
		children.select.connect(on_plant_selected)
		children.unselect.connect(on_plant_unselected)

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
