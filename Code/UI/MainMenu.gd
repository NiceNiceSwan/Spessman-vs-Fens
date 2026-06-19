extends Control

const LEVEL = preload("res://level.tscn")

@onready var button_container: VBoxContainer = $VBoxContainer
@onready var settings_menu: SettingsMenu = $SettingsMenu

func _ready():
	AudioServer.set_bus_volume_db(0, -25)
	AudioServer.set_bus_volume_db(2, -25)
	settings_menu._ready()

func _on_play_pressed():
	get_tree().change_scene_to_packed(LEVEL)

func _on_settings_pressed():
	button_container.set_visible(false)
	settings_menu.set_visible(true)
	
func _on_settings_menu_exiting():
	button_container.set_visible(true)
	settings_menu.set_visible(false)

func _on_quit_pressed():
	get_tree().quit()
