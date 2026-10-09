class_name ImmovableRodPlant extends Plant

const IMMOVABLE_ROD_SCENE: PackedScene = preload("uid://b5x5fuxp6eeaq")

func _ready() -> void:
	super()
	var immovable_rod: ImmovableRod = IMMOVABLE_ROD_SCENE.instantiate()
	immovable_rod.position.y = position.y
	get_tree().root.add_child(immovable_rod)
	_die()
