class_name Unlockable extends Resource

@export var name: String = "Unlockable"
@export_multiline var description: String = "If you see this, Swan fucked up!"
@export var texture: Texture2D
## the actual item this unlocks
@export var ID: Enums.UNLOCKS
