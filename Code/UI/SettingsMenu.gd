class_name SettingsMenu extends Control

@onready var master_volume_slider: HSlider = $PanelContainer/VBoxContainer/MasterBox/MasterSlider
@onready var SFX_volume_slider: HSlider = $PanelContainer/VBoxContainer/SFXBox/SFXSlider

signal exiting

func _ready() -> void:
	master_volume_slider.set_value(AudioServer.get_bus_volume_db(0))
	SFX_volume_slider.set_value(AudioServer.get_bus_volume_db(2))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") and is_visible():
		get_viewport().set_input_as_handled()
		revert()
		exiting.emit()

func _on_apply_button_pressed() -> void:
	var config = ConfigFile.new()
	var master_volume: float = master_volume_slider.get_value()
	var sfx_volume: float = SFX_volume_slider.get_value()
	config.load("user://settings.cfg")
	config.set_value("volume", "master", master_volume)
	config.set_value("volume", "sfx", sfx_volume)
	config.save("user://settings.cfg")
	AudioServer.set_bus_volume_db(0, master_volume)
	AudioServer.set_bus_volume_db(2, sfx_volume)
	exiting.emit()

func _on_revert_button_pressed() -> void:
	revert()
	exiting.emit()

func revert() -> void:
	master_volume_slider.set_value(AudioServer.get_bus_volume_db(0))
	SFX_volume_slider.set_value(AudioServer.get_bus_volume_db(2))
