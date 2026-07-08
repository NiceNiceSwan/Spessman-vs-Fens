class_name LevelSelector extends Control

@onready var return_button: Button = $Return

func _on_return_pressed():
	get_tree().change_scene_to_packed(preload("uid://cvtgxw33ajkq5"))
