class_name LevelSelector extends Control

const MAIN_MENU_SCENE: PackedScene = preload("uid://cvtgxw33ajkq5")

@onready var return_button: Button = $Return

func _on_return_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
