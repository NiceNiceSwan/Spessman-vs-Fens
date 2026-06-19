class_name SettingsMenu extends Control

@onready var master_volume_slider: HSlider = $PanelContainer/VBoxContainer/MasterBox/MasterSlider
@onready var SFX_volume_slider: HSlider = $PanelContainer/VBoxContainer/SFXBox/SFXSlider

signal exiting

func _ready():
	master_volume_slider.set_value(AudioServer.get_bus_volume_db(0))
	SFX_volume_slider.set_value(AudioServer.get_bus_volume_db(2))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") and is_visible():
		get_viewport().set_input_as_handled()
		revert()
		exiting.emit()
	

func _on_apply_button_pressed():
	AudioServer.set_bus_volume_db(0, master_volume_slider.get_value())
	AudioServer.set_bus_volume_db(2, SFX_volume_slider.get_value())
	exiting.emit()

func _on_revert_button_pressed():
	revert()
	exiting.emit()

func revert():
	master_volume_slider.set_value(AudioServer.get_bus_volume_db(0))
	SFX_volume_slider.set_value(AudioServer.get_bus_volume_db(2))
