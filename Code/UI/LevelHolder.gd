class_name LevelHolder extends Control

@export var level_name: String = "Level"
@export var level_data: LevelResource
#@export var level_to_load

@onready var level_label: Label = $Button/Label
@onready var button: Button = $Button

signal level_entered

func _ready():
	level_label.text = level_name
	if not level_data:
		return
	
	if level_data.unlocks == null:
		if SaveData.unlocked_plants < 7:
			button.set_disabled(true)
			level_label.label_settings.font_color = Color(0.25, 0.25, 0.25)
			var stylebox: StyleBoxFlat =  button.get_theme_stylebox("normal").duplicate()
			stylebox.bg_color = Color(0.01, 0.01, 0.01, 1)
			button.add_theme_stylebox_override("normal", stylebox)
		elif SaveData.unlocked_plants == Enums.UNLOCKS.ALL:
			var stylebox: StyleBoxFlat =  button.get_theme_stylebox("normal").duplicate()
			stylebox.bg_color = Color(0.18, 1, 0.18)
			button.add_theme_stylebox_override("normal", stylebox)
		return
	
	if SaveData.unlocked_plants > level_data.unlocks.ID - 1:
		var stylebox: StyleBoxFlat =  button.get_theme_stylebox("normal").duplicate()
		stylebox.bg_color = Color(0.18, 1, 0.18)
		button.add_theme_stylebox_override("normal", stylebox)
	elif SaveData.unlocked_plants < level_data.unlocks.ID - 1:
		button.set_disabled(true)
		level_label.label_settings.font_color = Color(0.25, 0.25, 0.25)
		var stylebox: StyleBoxFlat =  button.get_theme_stylebox("normal").duplicate()
		stylebox.bg_color = Color(0.01, 0.01, 0.01, 1)
		button.add_theme_stylebox_override("normal", stylebox)

func _on_button_pressed():
	var level: Level = preload("uid://beg53cvd5kur8").instantiate()
	level.level_data = level_data
	get_tree().root.add_child(level)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = level
