class_name PauseMenu extends Control

signal open_settings

func _on_resume_pressed():
	get_tree().set_pause(false)
	visible = false

func _on_settings_pressed():
	open_settings.emit()

func _on_quit_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene_to_packed(load("res://Code/UI/MainMenu.tscn"))
