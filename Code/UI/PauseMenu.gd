class_name PauseMenu extends Control

@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var options_container: VBoxContainer = $OptionsContainer

var open_settings: bool = false

func disable() -> void:
	open_settings = false
	settings_menu.set_visible(false)
	settings_menu.revert()
	set_visible(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if not get_tree().is_paused():
			get_tree().set_pause(true)
			set_visible(true)
			return
		
		if open_settings:
			return
		
		get_viewport().set_input_as_handled()
		get_tree().set_pause(false)
		set_visible(!visible)

func _on_resume_pressed() -> void:
	get_tree().set_pause(false)
	visible = false

func _on_settings_pressed() -> void:
	open_settings = true
	options_container.set_visible(false)
	settings_menu.set_visible(true)

func _on_settings_menu_exiting() -> void:
	open_settings = false
	options_container.set_visible(true)
	settings_menu.set_visible(false)

func _on_quit_pressed() -> void:
	get_tree().set_pause(false)
	get_tree().change_scene_to_packed(load("uid://cvtgxw33ajkq5"))
