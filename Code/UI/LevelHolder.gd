class_name LevelHolder extends Control

@export var level_name: String = "Level"
#@export var level_to_load

@onready var level_label: Label = $Button/Label

func _ready():
	level_label.text = level_name

func _on_button_pressed():
	pass # Replace with function body.
