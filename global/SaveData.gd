extends Node

var unlocked_plants: Enums.UNLOCKS = Enums.UNLOCKS.ALL

func save_game() -> void:
	var save_file: FileAccess = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_data: Dictionary = { "unlocked_plants": unlocked_plants }
	var json_string: String = JSON.stringify(save_data)
	save_file.store_line(json_string)

func game_save_exists() -> bool:
	if not FileAccess.file_exists("user://savegame.save"):
		return false
	return true

func load_game() -> void:
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	var save_file: FileAccess = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string: String = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json: JSON = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result: Error = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data: Variant = json.data
		unlocked_plants = node_data["unlocked_plants"]
