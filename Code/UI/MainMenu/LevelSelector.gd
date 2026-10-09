class_name LevelSelector extends Control

const MAIN_MENU_SCENE: PackedScene = preload("uid://cvtgxw33ajkq5")
const NUMBER_OF_LEVEL_PAGES: int = 2

@export var level_sets: Array[LevelSet]

@onready var return_button: Button = $Return
@onready var next_page_button: Button = $HBoxContainer/NextPageButton
@onready var previous_page_button: Button = $HBoxContainer/PreviousPageButton

# the level page on which we are. starts from 0
var level_page: int = 0

func _change_level_page(page: int) -> void:
	previous_page_button.set_disabled(false)
	next_page_button.set_disabled(false)
	level_page = page
	if page == 0:
		previous_page_button.set_disabled(true)
	if page == NUMBER_OF_LEVEL_PAGES:
		next_page_button.set_disabled(true)

func _on_return_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)

func _on_previous_page_button_pressed() -> void:
	_change_level_page(level_page - 1)

func _on_next_page_button_pressed() -> void:
	_change_level_page(level_page + 1)
