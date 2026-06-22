extends Control

const LEVEL = preload("res://Code/UI/LevelSelector.tscn")

@onready var button_container: VBoxContainer = $VBoxContainer
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var load_game: Button = $VBoxContainer/LoadGame

func _ready():
	SaveData.unlocked_plants = Enums.UNLOCKS.NONE
	AudioServer.set_bus_volume_db(0, -10)
	AudioServer.set_bus_volume_db(2, -10)
	settings_menu._ready()
	if SaveData.game_save_exists():
		load_game.set_disabled(false)

func _on_new_game_pressed():
	get_tree().change_scene_to_packed(LEVEL)

func _on_load_game_pressed():
	SaveData.load_game()
	get_tree().change_scene_to_packed(LEVEL)

func _on_settings_pressed():
	button_container.set_visible(false)
	settings_menu.set_visible(true)
	
func _on_settings_menu_exiting():
	button_container.set_visible(true)
	settings_menu.set_visible(false)

func _on_quit_pressed():
	get_tree().quit()
