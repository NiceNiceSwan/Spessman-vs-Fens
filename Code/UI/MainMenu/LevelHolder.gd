class_name LevelHolder extends Control

var NORMAL_LEVEL_SCENE: PackedScene = load("uid://b6adntembm034")
var CONVEYOR_LEVEL_SCENE: PackedScene = load("uid://b6ax1g5nktl")

enum level_options {
	normal_level,
	conveyor_level
}

var level_scene: PackedScene = NORMAL_LEVEL_SCENE

@export var level_name: String = "Level"
@export var level_type: level_options = level_options.normal_level
## Array of towers that are pre-set on this level. Right now only works for conveyor levels.
@export var tower_selection: TowerPreset
@export var level_data: LevelResource

@onready var level_label: Label = $Button/Label
@onready var button: Button = $Button

#signal level_entered

func _ready() -> void:
	level_label.text = level_name
	if not level_data:
		return
	
	match level_type:
		level_options.normal_level:
			level_scene = NORMAL_LEVEL_SCENE
		level_options.conveyor_level:
			level_scene = CONVEYOR_LEVEL_SCENE
	
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

func _on_button_pressed() -> void:
	var level: Level = level_scene.instantiate()
	level.level_data = level_data
	get_tree().root.add_child(level)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = level
	if not tower_selection == null:
		level._initialize_preset_towers(tower_selection)
