extends Control

const LEVEL = preload("uid://bavn0ly1fcl5v")

@onready var button_container: VBoxContainer = $VBoxContainer
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var load_game: Button = $VBoxContainer/LoadGame

func _ready() -> void:
	var config: ConfigFile = ConfigFile.new()
	var master_volume: float = -10
	var sfx_volume: float = -10
	if config.load("user://settings.cfg"):
		config.set_value("volume", "master", -10)
		config.set_value("volume", "sfx", -10)
		config.save("user://settings.cfg")
	else:
		master_volume = config.get_value("volume", "master")
		sfx_volume = config.get_value("volume", "sfx")
	SaveData.unlocked_plants = Enums.UNLOCKS.NONE
	AudioServer.set_bus_volume_db(0, master_volume)
	AudioServer.set_bus_volume_db(2, sfx_volume)
	settings_menu._ready()
	if SaveData.game_save_exists():
		load_game.set_disabled(false)

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL)

func _on_load_game_pressed() -> void:
	SaveData.load_game()
	get_tree().change_scene_to_packed(LEVEL)

func _on_settings_pressed() -> void:
	button_container.set_visible(false)
	settings_menu.set_visible(true)
	
func _on_settings_menu_exiting() -> void:
	button_container.set_visible(true)
	settings_menu.set_visible(false)

func _on_quit_pressed() -> void:
	get_tree().quit()
